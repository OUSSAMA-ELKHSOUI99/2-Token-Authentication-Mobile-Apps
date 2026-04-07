import 'package:authentication/features/presentation/states/login_form_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_controller.dart'; // main auth controller


class LoginFormController extends Notifier<LoginFormState> {
  @override
  LoginFormState build() => LoginFormState();

  void updateEmail(String value) => state = state.copyWith(email: value, clearError: true);
  void updatePassword(String value) => state = state.copyWith(password: value, clearError: true);

  Future<void> submit() async {
    if (state.email.isEmpty || state.password.isEmpty) {
      state = state.copyWith(error: 'Please fill in all fields');
      return;
    }

    state = state.copyWith(isSubmitting: true);

    try {
      // Call the main AuthController's login method!
      await ref.read(authControllerProvider.notifier).login(
        state.email, 
        state.password,
      );
      // If successful, AuthWrapper sees the user and routes to HomeScreen automatically
    } catch (e) {
      // Catch the "Invalid credentials" error from our LocalAuthRepository
      state = state.copyWith(error: 'Invalid email or password');
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }
}

final loginFormProvider = NotifierProvider<LoginFormController, LoginFormState>(() {
  return LoginFormController();
});