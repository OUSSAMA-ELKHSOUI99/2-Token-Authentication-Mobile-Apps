// presentation/ui/login_screen.dart
import 'package:authentication/features/presentation/controllers/login_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  final VoidCallback onToggle; // The function to switch to Registration

  const LoginScreen({super.key, required this.onToggle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(loginFormProvider);
    final formController = ref.read(loginFormProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: formController.updateEmail,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextField(
              onChanged: formController.updatePassword,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            
            // Display general form errors (like Invalid Credentials)
            if (formState.error != null) ...[
              const SizedBox(height: 16),
              Text(
                formState.error!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
            
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: formState.isSubmitting ? null : formController.submit,
              child: formState.isSubmitting 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) 
                  : const Text('Login'),
            ),
            const SizedBox(height: 16),
            
            // The magic button that switches to the Registration Screen
            TextButton(
              onPressed: formState.isSubmitting ? null : onToggle,
              child: const Text('Don\'t have an account? Sign up'),
            )
          ],
        ),
      ),
    );
  }
}