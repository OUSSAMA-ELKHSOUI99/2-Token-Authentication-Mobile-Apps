class LoginFormState {
  final String email;
  final String password;
  final String? error;
  final bool isSubmitting;
  final bool isPasswordVisible;

  LoginFormState({this.email = '', this.password = '', this.error, this.isSubmitting = false, this.isPasswordVisible = false,});

  LoginFormState copyWith({String? email, String? password, String? error, bool? isSubmitting, bool clearError = false, bool? isPasswordVisible,}) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      error: clearError ? null : (error ?? this.error),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }
}