// import 'package:authentication/features/auth/domain/repositories/i_auth_repository.dart';
// import 'package:authentication/features/providers/auth_providers.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class AuthInterceptor extends Interceptor{
//   final Dio dio;
//   // final IAuthRepository authRepository;
//   final Ref ref;
//   final FlutterSecureStorage secureStorage;

//   AuthInterceptor(this.dio, this.ref, this.secureStorage);

//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
//     // Attach the access token to every outgoing request
//     final accessToken = await secureStorage.read(key: 'access_token');
//     if (accessToken != null) {
//       options.headers['Authorization'] = 'Bearer $accessToken';
//     }
//     // add the token
//     return handler.next(options);
//   }

//   // @override
//   // void onError(DioException err, ErrorInterceptorHandler handler) async {
//   //   // If the error is 401 (Unauthorized), the access token expired!
//   //   if (err.response?.statusCode == 401) {
//   //     final refreshToken = await secureStorage.read(key: 'refresh_token');
      
//   //     if (refreshToken != null) {
//   //       try {
//   //         // 1. Call your repository to get new tokens
//   //         final authRepository = ref.read(authRepositoryProvider);
//   //         final newTokens = await authRepository.refreshSession(refreshToken);
          
//   //         // 2. Retry the original request with the NEW access token
//   //         final options = err.requestOptions;
//   //         options.headers['Authorization'] = 'Bearer ${newTokens.accessToken}';
          
//   //         // 3. Resend the request
//   //         final cloneReq = await dio.fetch(options);
//   //         // send the successful data back to the UI
//   //         return handler.resolve(cloneReq);
          
//   //       } catch (e) {
//   //         // If the refresh token is ALSO expired or invalid, log the user out entirely
//   //         final authRepository = ref.read(authRepositoryProvider);
//   //         await authRepository.logout();
//   //         // You would also trigger your Riverpod AuthController to push the user to the Login screen here
//   //       }
//   //     }
//   //   }
//   //   return handler.next(err);
//   // }
//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) async {
//     print('🚨 INTERCEPTOR CAUGHT AN ERROR: ${err.response?.statusCode}');

//     if (err.response?.statusCode == 401) {
//       print('🔄 401 DETECTED: Looking for refresh token...');
      
//       // CHECK YOUR SPELLING HERE! Make sure it matches your repository!
//       final refreshToken = await secureStorage.read(key: 'refresh_token'); 
      
//       print('🔑 REFRESH TOKEN FOUND: $refreshToken');

//       if (refreshToken != null) {
//         try {
//           print('🚀 SENDING REFRESH REQUEST TO PYTHON...');
          
//           // Read the repository lazily to avoid circular dependencies!
//           final authRepository = ref.read(authRepositoryProvider);
//           final newTokens = await authRepository.refreshSession(refreshToken);
          
//           print('✅ REFRESH SUCCESSFUL! Retrying original request...');
//           final options = err.requestOptions;
//           options.headers['Authorization'] = 'Bearer ${newTokens.accessToken}';
          
//           final cloneReq = await dio.fetch(options);
//           return handler.resolve(cloneReq);
          
//         } catch (e) {
//           print('❌ REFRESH FAILED: $e');
//           // Optional: Force logout if refresh fails
//           // await ref.read(authRepositoryProvider).logout();
//         }
//       } else {
//         print('⚠️ NO REFRESH TOKEN IN STORAGE. Giving up.');
//       }
//     }
//     return handler.next(err);
//   }
// }

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage secureStorage;
  final Dio dio; // The main Dio instance used to retry the request

  // Notice: 'Ref' is completely gone from the constructor!
  AuthInterceptor(this.secureStorage, this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await secureStorage.read(key: 'access_token');
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    print('🚨 INTERCEPTOR CAUGHT AN ERROR: ${err.response?.statusCode}');

    if (err.response?.statusCode == 401) {
      print('🔄 401 DETECTED: Looking for refresh token...');
      final refreshToken = await secureStorage.read(key: 'refresh_token'); 
      print('🔑 REFRESH TOKEN FOUND: $refreshToken');

      if (refreshToken != null) {
        try {
          print('🚀 SENDING REFRESH REQUEST TO PYTHON (Using Naked Dio)...');
          
          // 1. Create a separate, naked Dio instance just for refreshing
          // This completely bypasses the circular dependency!
          final refreshDio = Dio(BaseOptions(baseUrl: 'http://127.0.0.1:8000'));
          
          // 2. Make the HTTP call directly
          final response = await refreshDio.post('/refresh', data: {
            'refresh_token': refreshToken,
          });
          
          // 3. Extract the new tokens from Python's response
          final newAccessToken = response.data['accessToken'];
          final newRefreshToken = response.data['refreshToken'];
          
          // 4. Save them directly using the secureStorage we already have
          await secureStorage.write(key: 'access_token', value: newAccessToken);
          await secureStorage.write(key: 'refresh_token', value: newRefreshToken);
          
          print('✅ REFRESH SUCCESSFUL! Retrying original request...');
          
          // 5. Update the original request with the brand new access token
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newAccessToken';
          
          // 6. Retry the original request
          final cloneReq = await dio.fetch(options);
          return handler.resolve(cloneReq);
          
        } catch (e) {
          print('❌ REFRESH FAILED: $e');
          // If the refresh token is dead, clear storage so the user is forced to log in again
          await secureStorage.delete(key: 'access_token');
          await secureStorage.delete(key: 'refresh_token');
        }
      } else {
        print('⚠️ NO REFRESH TOKEN IN STORAGE. Giving up.');
      }
    }
    return handler.next(err);
  }
}