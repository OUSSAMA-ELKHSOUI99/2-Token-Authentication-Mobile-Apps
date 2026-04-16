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
  static const String _baseUrl = 'http://127.0.0.1:8000'; 

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
      print(e);
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
  try {
    final response = await dio.post('$_baseUrl/register', data: {
      'email': email,
      'password': password,
      'name': name, 
    });
    
    // 1. The Python API returns the tokens directly! Just read them.
    final tokens = TokenPair(
      accessToken: response.data['accessToken'],
      refreshToken: response.data['refreshToken'],
    );
    
    // 2. Save them securely
    await _saveTokens(tokens);
    return tokens;

  } on DioException catch (e) {
    if (e.response?.statusCode == 400) {
      throw Exception('Email already in use'); // Handle the specific Python 400 error
    }
    throw Exception('Network error');
  }
}

@override
Future<TokenPair> refreshSession(String oldRefreshToken) async {
  try {
    final response = await dio.post('$_baseUrl/refresh', data: {
      'refresh_token': oldRefreshToken, // Name must match Python's Pydantic model exactly!
    });
    
    // 1. Read the REAL new tokens from the Python response
    final newTokens = TokenPair(
      accessToken: response.data['accessToken'],
      refreshToken: response.data['refreshToken'], 
    );
  
    // 2. Save the new ones over the old ones
    await _saveTokens(newTokens);
    return newTokens;

  } on DioException catch (e) {
    if (e.response?.statusCode == 401) {
      throw Exception('Session expired entirely. Please log in again.');
    }
    throw Exception('Network error');
  }
}

  @override
  Future<void> logout() async {
    await secureStorage.delete(key: _accessTokenKey);
    await secureStorage.delete(key: _refreshTokenKey);
  }
}