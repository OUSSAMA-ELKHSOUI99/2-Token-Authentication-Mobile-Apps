import 'package:authentication/features/auth/domain/failures/auth_failure.dart';
import 'package:authentication/features/presentation/states/login_form_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_controller.dart'; // main auth controller


class LoginFormController extends Notifier<LoginFormState> {
  @override
  LoginFormState build() => LoginFormState();

  void updateEmail(String value) => state = state.copyWith(email: value, clearError: true);
  void updatePassword(String value) => state = state.copyWith(password: value, clearError: true);

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }
  
  Future<void> submit() async {
    if (state.email.isEmpty || state.password.isEmpty) {
      state = state.copyWith(error: 'Please fill in all fields');
      return;
    }

    state = state.copyWith(isSubmitting: true);

    try {
      state = state.copyWith(isSubmitting: true, clearError: true);
      // Call the main AuthController's login method!
      await ref.read(authControllerProvider.notifier).login(
        state.email, 
        state.password,
      );
      // If successful, AuthWrapper sees the user and routes to HomeScreen automatically
    } on UserNotFoundException {
  // Specifically catch the User Not Found error
  state = state.copyWith(error: 'We couldn\'t find an account with that email. Please sign up!');
  
} on InvalidPasswordException {
  // Specifically catch the wrong password error
  state = state.copyWith(error: 'Incorrect password. Please try again.');
  
} catch (e) {
      
      state = state.copyWith(error: 'An unexpected error occurred. Please try again.');
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }
}

final loginFormProvider = NotifierProvider<LoginFormController, LoginFormState>(() {
  return LoginFormController();
});