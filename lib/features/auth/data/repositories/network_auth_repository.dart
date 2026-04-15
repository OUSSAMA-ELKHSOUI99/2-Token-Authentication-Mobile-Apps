import 'package:dio/dio.dart';
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

class NetworkAuthRepository implements IAuthRepository {
  final FlutterSecureStorage secureStorage;
  final Dio dio; // Inject Dio instead of a database

  NetworkAuthRepository(this.secureStorage, this.dio);

  // If using Android Emulator, point to 10.0.2.2. If iOS simulator, 127.0.0.1.
  static const String _baseUrl = 'http://10.0.2.2:8000'; 

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  Future<void> _saveTokens(TokenPair tokens) async {
    await secureStorage.write(key: _accessTokenKey, value: tokens.accessToken);
    await secureStorage.write(key: _refreshTokenKey, value: tokens.refreshToken);
  }

  @override
  Future<User?> getCurrentUser() async {
    final accessToken = await secureStorage.read(key: _accessTokenKey);
    if (accessToken == null) return null; 

    try {
      // We just decode the payload without verifying the secret key
      final jwt = JWT.decode(accessToken);
      final payload = jwt.payload;
      
      return User(
        id: payload['id'].toString(), 
        email: payload['email'], 
        displayName: payload['name'] ?? 'User',
      );
    } catch (e) {
      return null; 
    }
  }

  @override
  Future<TokenPair> loginWithEmail(String email, String password) async {
    try {
      final response = await dio.post('$_baseUrl/login', data: {
        'email': email,
        'password': password,
        'name': '', // Backend defaults this
      });

      // The Python API returns JSON: {"accessToken": "...", "refreshToken": "..."}
      final tokens = TokenPair(
        accessToken: response.data['accessToken'],
        refreshToken: response.data['refreshToken'],
      );
      
      await _saveTokens(tokens);
      return tokens;

    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Invalid email or password');
      }
      throw Exception('Network error');
    }
  }

  // ... register and refresh methods look identical to login, 
  // just calling dio.post('$_baseUrl/register') and handling the response!

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