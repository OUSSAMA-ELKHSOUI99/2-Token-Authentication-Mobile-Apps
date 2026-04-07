import 'package:authentication/features/auth/domain/entities/token_pair.dart';
import 'package:authentication/features/auth/domain/entities/user.dart';

abstract class IAuthRepository {
  Future<User?> getCurrentUser();
  Future<TokenPair> loginWithEmail(String email, String password);
  Future<TokenPair> registerWithEmail(String email, String password, String name);
  Future<TokenPair> refreshSession(String oldRefrechToken);
  Future<void> logout();
}