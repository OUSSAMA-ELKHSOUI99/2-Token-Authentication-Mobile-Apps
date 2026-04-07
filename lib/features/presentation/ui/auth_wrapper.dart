import 'package:authentication/features/presentation/controllers/auth_controller.dart';
import 'package:authentication/features/presentation/ui/auth_switch_screen.dart';
import 'package:authentication/features/presentation/ui/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This makes the UI rebuild automatically whenever the state changes.
    final authState = ref.watch(authControllerProvider);

    // Because authControllerProvider is an AsyncNotifier, it handles 
    // loading, error, and data states for you!
    return authState.when(
      data: (user) {
        if (user != null) {
          return const HomeScreen(); // Authenticated!
        } else {
          return const AuthSwitchScreen(); // Unauthenticated!
        }
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
    );
  }
}