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

  Future<void> register(String email, String password, {String name = 'New User'}) async {
    // 1. Tell the UI we are loading
    state = const AsyncValue.loading();
    
    try {
      final repo = ref.read(authRepositoryProvider);
      
      // 2. Call the repository to create the user and generate tokens
      await repo.registerWithEmail(email, password, name);
      
      // 3. The tokens are now in secure storage. 
      // We can just fetch the current user to update our state!
      final user = await repo.getCurrentUser();
      state = AsyncValue.data(user);
      
    } catch (e, stack) {
      // 4. If it fails, update the state to error (prevents infinite loading)
      state = AsyncValue.error(e, stack);
      
      // 5. RETHROW the error so the RegistrationFormController catches it
      // and updates the formState.emailError!
      rethrow; 
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