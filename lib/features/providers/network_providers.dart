// core/providers/network_providers.dart
import 'package:authentication/features/core/network/auth_interceptor.dart';
import 'package:authentication/features/providers/auth_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod/src/framework.dart';

// Provide the base Dio instance
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:8000', // Your Python API address
      connectTimeout: const Duration(seconds: 10),
    ),
  );

  // We add the interceptor here!
  // We use ref.read to grab our storage and repository securely
  dio.interceptors.add(
    AuthInterceptor(
      ref.read(secureStorageProvider as ProviderListenable<Dio>),
      ref.read(authRepositoryProvider),
      dio as FlutterSecureStorage,
    ),
  );

  return dio;
});