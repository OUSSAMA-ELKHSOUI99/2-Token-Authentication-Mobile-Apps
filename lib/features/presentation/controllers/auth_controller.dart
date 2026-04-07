import 'package:authentication/features/auth/domain/entities/user.dart';
import 'package:authentication/features/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// The state can be an AsyncValue<User?>, which handles loading/error states for free.
class AuthController extends AsyncNotifier<User?> {
  
  @override
  Future<User?> build() async {
    // App startup: Check if user is already logged in
    final repo = ref.read(authRepositoryProvider);
    return await repo.getCurrentUser();
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final user = await repo.loginWithEmail(email, password);
      // Update state to authenticated
      state = AsyncValue.data(user as User?);
    } catch (e, stack) {
      // Handles your custom Domain failures
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    final repo = ref.read(authRepositoryProvider);
    await repo.logout();
    state = const AsyncValue.data(null); // Unauthenticated
  }
}

// 3. Provide the Controller
final authControllerProvider = AsyncNotifierProvider<AuthController, User?>(() {
  return AuthController();
});