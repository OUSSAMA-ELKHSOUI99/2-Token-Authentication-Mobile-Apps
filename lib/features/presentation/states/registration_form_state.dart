// presentation/states/registration_form_state.dart
class RegistrationFormState {
  final String email;
  final String password;
  final String? emailError;
  final String? passwordError;
  final bool isSubmitting;

  RegistrationFormState({
    this.email = '',
    this.password = '',
    this.emailError,
    this.passwordError,
    this.isSubmitting = false,
  });

  // copyWith allows us to update one field while keeping the rest exactly the same
  RegistrationFormState copyWith({
    String? email,
    String? password,
    String? emailError,
    String? passwordError,
    bool? isSubmitting,
    bool clearEmailError = false,
    bool clearPasswordError = false,
  }) {
    return RegistrationFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      emailError: clearEmailError ? null : (emailError ?? this.emailError),
      passwordError: clearPasswordError ? null : (passwordError ?? this.passwordError),
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}