abstract class AuthFailure implements Exception {}
class InvalidCredentialsFailure extends AuthFailure {}
class EmailAlreadyInUseFailure extends AuthFailure {}