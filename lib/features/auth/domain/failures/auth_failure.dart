abstract class AuthFailure implements Exception {}
class InvalidCredentialsFailure extends AuthFailure {}
class EmailAlreadyInUseFailure extends AuthFailure {}

class UserNotFoundException implements Exception {
  final String message = 'No account found with this email.';
}

class InvalidPasswordException implements Exception {
  final String message = 'The password you entered is incorrect.';
}