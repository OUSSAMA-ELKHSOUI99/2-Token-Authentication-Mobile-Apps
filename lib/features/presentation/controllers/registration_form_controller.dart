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

  void updateFullName(String value) {
    state = state.copyWith(fullName: value, clearFullNameError: true);
  }

  void updateConfirmPassword(String value) {
    state = state.copyWith(confirmPassword: value, clearConfirmPasswordError: true);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }
  
  void toggleAgreedToTerms() {
    state = state.copyWith(agreedToTerms: !state.agreedToTerms);
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

    if (emailError != null ) {
      // Update state with errors and return false
      state = state.copyWith(
        error: emailError, 
       
      );
      return false;
    }
    if ( passwordError != null) {
      // Update state with errors and return false
      state = state.copyWith(
        
        error: passwordError
      );
      return false;
    }
    return true; // Form is valid
  }

  Future<void> submit() async {
    if (!_validate()) return;
    // 1. Basic Validation
    if (state.fullName.isEmpty || state.email.isEmpty || state.password.isEmpty || state.confirmPassword.isEmpty) {
      // You can set specific errors here, or a general one
      state = state.copyWith(error: 'Please fill in all fields');
      return;
    }

    if (state.password != state.confirmPassword) {
      state = state.copyWith(error: 'Passwords do not match');
      return;
    }

    if (!state.agreedToTerms) {
      state = state.copyWith(error: 'You must agree to the Terms and Conditions.');
      // Handle terms error (maybe show a snackbar in the UI since there's no error text field for the checkbox)
      return;
    }

    // 2. Proceed with submission
    state = state.copyWith(isSubmitting: true);

    try {
      // Call your AuthController or Repository here
      // await ref.read(authControllerProvider.notifier).register(...);
      await ref.read(authControllerProvider.notifier).register(
        state.email, 
        state.password,
        state.fullName
      );
      
    } catch (e) {
      // Handle backend errors
      state = state.copyWith(error: 'Registration failed. Please try again.');
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }
}

// Provide the Form Controller
final registrationFormProvider = NotifierProvider<RegistrationFormController, RegistrationFormState>(() {
  return RegistrationFormController();
});