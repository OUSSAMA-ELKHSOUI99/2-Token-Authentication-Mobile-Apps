class LoginFormState {
  final String email;
  final String password;
  final String? error;
  final bool isSubmitting;

  LoginFormState({this.email = '', this.password = '', this.error, this.isSubmitting = false});

  LoginFormState copyWith({String? email, String? password, String? error, bool? isSubmitting, bool clearError = false}) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      error: clearError ? null : (error ?? this.error),
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}