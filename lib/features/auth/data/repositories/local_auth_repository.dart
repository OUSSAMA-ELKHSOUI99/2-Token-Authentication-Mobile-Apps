import 'dart:convert';
import 'package:authentication/features/auth/domain/failures/auth_failure.dart';
import 'package:crypto/crypto.dart';
import 'package:authentication/features/auth/domain/entities/token_pair.dart';
import 'package:authentication/features/auth/domain/entities/user.dart';
import 'package:authentication/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:sqflite/sqflite.dart'; // Or Isar, if you prefer
import 'package:uuid/uuid.dart';

// when ready to connect to a real backend, 
//you simply swap out the LocalAuthRepository for a NetworkAuthRepository 
//that hits real API endpoints
class LocalAuthRepository implements IAuthRepository{

  final Database localDb;
  final FlutterSecureStorage secureStorage;

  LocalAuthRepository(this.secureStorage, this.localDb);

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refrech_token';
  // A dummy secret key just for local generation (a real backend uses its own hidden secret)
  static const String _jwtSecret = 'my_super_secret_indie_key';

  Future<void> _saveTokens(TokenPair tokens) async {
    await secureStorage.write(key: _accessTokenKey, value: tokens.accessToken);
    await secureStorage.write(key: _refreshTokenKey, value: tokens.refreshToken);
  }

  @override
  Future<User?> getCurrentUser() async {
    // 1. Check if token exists in secure vault
    final accessToken = await secureStorage.read(key: _accessTokenKey);
    if (accessToken == null) return null;  // Unauthenticated
    
    // 2. If token exists, fetch user details from local SQLite DB using the token/ID
    try {
    // Decode the token (verifies the signature and expiration)
    final jwt = JWT.verify(accessToken, SecretKey(_jwtSecret));
    
    // Extract the data we embedded in the login method
    final payload = jwt.payload;
    
    return User(
      id: payload['id'].toString(), 
      email: payload['email'], 
      displayName: payload['name'] ?? 'User',
    );
    // } on JWTExpiredError {
    // // If access token is expired, we rely on the Interceptor to refresh it later,
    // // or you can try to refresh it right here.
    // return null; 
  } catch (e) {
    // Invalid token, tampering detected, etc.
    return null; 
  }
  }
  
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  @override
  Future<TokenPair> loginWithEmail(String email, String password) async {
    // --- 1. Validate credentials against local DB ---
    
    // Query your local SQLite users table
    final List<Map<String, dynamic>> maps = await localDb.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isEmpty) {
      throw UserNotFoundException(); // Or your custom UserNotFoundFailure
    }

    final userRecord = maps.first;
    final hashedPassword = _hashPassword(password);

    // Compare the stored hash with the input hash
    if (userRecord['password_hash'] != hashedPassword) {
      throw InvalidPasswordException();
    }

    // --- 2. Generate the tokens as JWTs ---
    
    // Create an Access Token (Expires quickly, e.g., 15 minutes)
    final accessJwt = JWT({
      'id': userRecord['id'],
      'email': userRecord['email'],
      'role': 'user', // Standard JWT claims
    });
    
    final accessToken = accessJwt.sign(
      SecretKey(_jwtSecret), 
      expiresIn: const Duration(minutes: 15),
    );

    // Create a Refresh Token (Expires in 30 days)
    final refreshJwt = JWT({
      'id': userRecord['id'],
      'type': 'refresh', 
    });
    
    final refreshToken = refreshJwt.sign(
      SecretKey(_jwtSecret), 
      expiresIn: const Duration(days: 30),
    );

    final tokens = TokenPair(accessToken: accessToken, refreshToken: refreshToken);
    
    // Save them to secure storage
    await _saveTokens(tokens);
    
    return tokens;
  }

  @override
  Future<TokenPair> registerWithEmail(String email, String password, String name) async {
  // 1. Check if the email is already taken
  final existingUsers = await localDb.query(
    'users',
    where: 'email = ?',
    whereArgs: [email],
  );

  if (existingUsers.isNotEmpty) {
    throw Exception('Email already in use'); // This will be caught by the form controller
  }

  // 2. Hash the password and generate a new ID
  final hashedPassword = _hashPassword(password);
  final newUserId = const Uuid().v4(); 

  // 3. Save the new user to the local SQLite database
  await localDb.insert('users', {
    'id': newUserId,
    'email': email,
    'name': name,
    'password_hash': hashedPassword,
  });

  // 4. Automatically log them in by generating the tokens
  // Since we already built loginWithEmail, we can just call it here!
  return await loginWithEmail(email, password);
  }

  @override
  Future<TokenPair> refreshSession(String oldRefreshToken) async {
    // In a real app, you send the oldRefreshToken to a /refresh endpoint.
    // The server verifies it hasn't been revoked, then issues new ones.
    
    // Simulate getting new tokens
    final newTokens = TokenPair(
      accessToken: "NEW_ACCESS_TOKEN_JWT",
      refreshToken: "NEW_REFRESH_TOKEN", 
    );
    
    await _saveTokens(newTokens);
    return newTokens;
  }

  @override
  Future<void> logout() async {
    await secureStorage.delete(key: _accessTokenKey);
    await secureStorage.delete(key: _refreshTokenKey);
  }

}