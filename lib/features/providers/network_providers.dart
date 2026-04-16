// core/providers/network_providers.dart
import 'package:authentication/features/core/network/auth_interceptor.dart';
import 'package:authentication/features/providers/auth_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod/src/framework.dart';

// Provide the base Dio instance
// final dioProvider = Provider<Dio>((ref) {
//   final dio = Dio(
//     BaseOptions(
//       baseUrl: 'http://10.0.2.2:8000', //  Python API address
//       connectTimeout: const Duration(seconds: 10),
//     ),
//   );

//   // We add the interceptor here!
//   // We use ref.read to grab our storage and repository securely
//   dio.interceptors.add(InterceptorsWrapper(
//     onRequest: (options, handler) {
//       // Use ref.read() here lazily at runtime, avoiding the compile-time cycle
//       final authRepo = ref.read(authRepositoryProvider);
//       final token = authRepo.getCurrentToken();
      
//       if (token != null) {
//         options.headers['Authorization'] = 'Bearer $token';
//       }
//       return handler.next(options);
//     },
//   )
//   );

//   return dio;
// });

final Provider<Dio> dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://127.0.0.1:8000',
      connectTimeout: const Duration(seconds: 10),
    ),
  );

  dio.interceptors.add(InterceptorsWrapper(
    // Note: onRequest is now async!
    onRequest: (options, handler) async {
      // 1. Read directly from storage, completely bypassing the AuthRepo loop
      final secureStorage = ref.read(secureStorageProvider);
      
      // 2. Read your token (make sure the string matches the key you use to save it)
      final token = await secureStorage.read(key: 'access_token'); 
      
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    },
  ));

  return dio;
});