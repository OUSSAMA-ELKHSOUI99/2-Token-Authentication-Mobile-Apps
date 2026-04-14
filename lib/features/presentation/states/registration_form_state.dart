// presentation/states/registration_form_state.dart
class RegistrationFormState {
  final String fullName;
  final String confirmPassword;
  final String? fullNameError;
  final String? confirmPasswordError;
  final String email;
  final String password;
  final String? emailError;
  final String? passwordError;
  final bool isSubmitting;
  final bool isPasswordVisible;
  final bool agreedToTerms;
  final String? error;

  RegistrationFormState({
    this.fullName = '',           // <--- Added
    this.email = '',
    this.password = '',
    this.confirmPassword = '',    // <--- Added
    this.fullNameError,
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
    this.isSubmitting = false,
    this.isPasswordVisible = false,
    this.agreedToTerms = false,
    this.error
  });

  // copyWith allows us to update one field while keeping the rest exactly the same
  RegistrationFormState copyWith({
    String? fullName,
    String? email,
    String? password,
    String? confirmPassword,
    String? fullNameError,
    String? emailError,
    String? passwordError,
    String? confirmPasswordError,
    bool? isSubmitting,
    bool clearFullNameError = false,
    bool clearEmailError = false,
    bool clearPasswordError = false,
    bool clearConfirmPasswordError = false,
    bool clearError = false,
    bool? isPasswordVisible,
    bool? agreedToTerms,
    String? error
  }) {
    return RegistrationFormState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      
      fullNameError: clearFullNameError ? null : (fullNameError ?? this.fullNameError),
      emailError: clearEmailError ? null : (emailError ?? this.emailError),
      passwordError: clearPasswordError ? null : (passwordError ?? this.passwordError),
      confirmPasswordError: clearConfirmPasswordError ? null : (confirmPasswordError ?? this.confirmPasswordError),
      
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      agreedToTerms: agreedToTerms ?? this.agreedToTerms,

      error: clearError ? null : (error ?? this.error)
    );
  }
}