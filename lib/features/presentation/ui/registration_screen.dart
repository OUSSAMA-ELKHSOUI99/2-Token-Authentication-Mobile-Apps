import 'package:authentication/features/presentation/controllers/registration_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegistrationScreen extends ConsumerWidget {
  final VoidCallback onToggle;
  const RegistrationScreen({super.key, required this.onToggle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the form state
    final formState = ref.watch(registrationFormProvider);
    // Get the notifier to trigger actions
    final formController = ref.read(registrationFormProvider.notifier);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: formController.updateEmail, // Update state on every keystroke
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: formState.emailError, // UI automatically shows the error
              ),
            ),
            TextField(
              onChanged: formController.updatePassword,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: formState.passwordError,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: formState.isSubmitting ? null : formController.submit,
              child: formState.isSubmitting 
                  ? const CircularProgressIndicator() 
                  : const Text('Register'),
            ),
            const SizedBox(height: 16),
            
            // The magic button that switches to the Registration Screen
            TextButton(
              onPressed: formState.isSubmitting ? null : onToggle,
              child: const Text('Already have an account? LogIn'),
            )
          ],
        ),
      ),
    );
  }
}