import 'package:authentication/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor{
  final Dio dio;
  final IAuthRepository authRepository;
  final FlutterSecureStorage secureStorage;

  AuthInterceptor(this.dio, this.authRepository, this.secureStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Attach the access token to every outgoing request
    final accessToken = await secureStorage.read(key: 'access_token');
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    // add the token
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // If the error is 401 (Unauthorized), the access token expired!
    if (err.response?.statusCode == 401) {
      final refreshToken = await secureStorage.read(key: 'refresh_token');
      
      if (refreshToken != null) {
        try {
          // 1. Call your repository to get new tokens
          final newTokens = await authRepository.refreshSession(refreshToken);
          
          // 2. Retry the original request with the NEW access token
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer ${newTokens.accessToken}';
          
          // 3. Resend the request
          final cloneReq = await dio.fetch(options);
          // send the successful data back to the UI
          return handler.resolve(cloneReq);
          
        } catch (e) {
          // If the refresh token is ALSO expired or invalid, log the user out entirely
          await authRepository.logout();
          // You would also trigger your Riverpod AuthController to push the user to the Login screen here
        }
      }
    }
    return handler.next(err);
  }
}