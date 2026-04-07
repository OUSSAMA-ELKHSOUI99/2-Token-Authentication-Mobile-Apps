// presentation/controllers/registration_form_controller.dart
import 'package:authentication/features/presentation/states/registration_form_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_controller.dart'; 

class RegistrationFormController extends Notifier<RegistrationFormState> {
  @override
  RegistrationFormState build() {
    return RegistrationFormState(); // Initial empty state
  }

  void updateEmail(String value) {
    // Optional: Validate as they type, or clear previous errors
    state = state.copyWith(email: value, clearEmailError: true);
  }

  void updatePassword(String value) {
    state = state.copyWith(password: value, clearPasswordError: true);
  }

  bool _validate() {
    String? emailError;
    String? passwordError;

    // Email Validation Regex
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(state.email)) {
      emailError = 'Please enter a valid email';
    }

    // Strong Password Validation (Min 8 chars, 1 uppercase, 1 number)
    final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$');
    if (!passwordRegex.hasMatch(state.password)) {
      passwordError = 'Must be 8+ chars, with 1 uppercase & 1 number';
    }

    if (emailError != null || passwordError != null) {
      // Update state with errors and return false
      state = state.copyWith(
        emailError: emailError, 
        passwordError: passwordError
      );
      return false;
    }
    return true; // Form is valid
  }

  Future<void> submit() async {
    // 1. Run validation before doing anything
    if (!_validate()) return; 

    // 2. Set loading state
    state = state.copyWith(isSubmitting: true);

    try {
      // 3. Call the main AuthController to actually hit the repository
      // Notice we use ref.read to access the other controller
      await ref.read(authControllerProvider.notifier).register(
        state.email, 
        state.password,
      );
      // If successful, the AuthWrapper UI will automatically route to Home
    } catch (e) {
      // Handle server/local DB errors (e.g., "Email already exists")
      state = state.copyWith(emailError: 'Email already exists');
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }
}

// Provide the Form Controller
final registrationFormProvider = NotifierProvider<RegistrationFormController, RegistrationFormState>(() {
  return RegistrationFormController();
});