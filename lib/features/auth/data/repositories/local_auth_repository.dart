import 'package:authentication/features/auth/domain/entities/token_pair.dart';
import 'package:authentication/features/auth/domain/entities/user.dart';
import 'package:authentication/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalAuthRepository implements IAuthRepository{

  final FlutterSecureStorage secureStorage;

  LocalAuthRepository(this.secureStorage);

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refrech_token';

  Future<void> _saveTokens(TokenPair tokens) async {
    await secureStorage.write(key: _accessTokenKey, value: tokens.accessToken);
    await secureStorage.write(key: _refreshTokenKey, value: tokens.refreshToken);
  }

  @override
  Future<User?> getCurrentUser() async {
    // 1. Check if token exists in secure vault
    final token = await secureStorage.read(key: _refreshTokenKey);
    if (token == null) return null; // Unauthenticated
    
    // 2. If token exists, fetch user details from local SQLite DB using the token/ID
    // return User(id: '123', email: 'test@test.com', displayName: 'Oussama');
  }
  
  @override
  Future<TokenPair> loginWithEmail(String email, String password) async {
    // 1. Validate credentials against your local DB
    // 2. Generate the tokens (In a real app, your API returns these as JWTs)
    final tokens = TokenPair(
      accessToken: "eyJhbGciOiJIUzI1NiIsIn... (short lived)", 
      refreshToken: "dGhpcy1pcy1hLWxvbmctcmVmcmVzaC10b2tlbg... (long lived)"
    );
    
    await _saveTokens(tokens);
    return tokens;
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