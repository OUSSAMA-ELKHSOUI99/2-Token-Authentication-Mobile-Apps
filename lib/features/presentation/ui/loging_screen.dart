// presentation/ui/login_screen.dart
import 'dart:ui';

import 'package:authentication/features/const/const.dart';
import 'package:authentication/features/presentation/controllers/login_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  final VoidCallback onToggle; // The function to switch to Registration

  const LoginScreen({super.key, required this.onToggle});
  // bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(loginFormProvider);
    final formController = ref.read(loginFormProvider.notifier);
    
    return Scaffold(
      // appBar: AppBar(title: const Text('Login')),
      // body: Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       TextField(
      //         onChanged: formController.updateEmail,
      //         decoration: const InputDecoration(labelText: 'Email'),
      //       ),
      //       const SizedBox(height: 16),
      //       TextField(
      //         onChanged: formController.updatePassword,
      //         obscureText: true,
      //         decoration: const InputDecoration(labelText: 'Password'),
      //       ),
            
      //       // Display general form errors (like Invalid Credentials)
      //       if (formState.error != null) ...[
      //         const SizedBox(height: 16),
      //         Text(
      //           formState.error!,
      //           style: const TextStyle(color: Colors.red),
      //         ),
      //       ],
            
      //       const SizedBox(height: 24),
      //       ElevatedButton(
      //         onPressed: formState.isSubmitting ? null : formController.submit,
      //         child: formState.isSubmitting 
      //             ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) 
      //             : const Text('Login'),
      //       ),
      //       const SizedBox(height: 16),
            
      //       // The magic button that switches to the Registration Screen
      //       TextButton(
      //         onPressed: formState.isSubmitting ? null : onToggle,
      //         child: const Text('Don\'t have an account? Sign up'),
      //       )
      //     ],
      //   ),
      // ),
      body: Stack(
        children: [
          // Background Ethereal Blobs
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: secondaryContainer.withOpacity(0.4),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryContainer.withOpacity(0.3),
              ),
            ),
          ),
          // Blur layer to create the ethereal effect
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(color: Colors.transparent),
            ),
          ),

          // Main Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header / Logo
                      // Column(
                      //   children: [
                      //     Container(
                      //       width: 56,
                      //       height: 56,
                      //       decoration: BoxDecoration(
                      //         gradient: LinearGradient(
                      //           colors: [primary, primaryContainer],
                      //           begin: Alignment.topRight,
                      //           end: Alignment.bottomLeft,
                      //         ),
                      //         borderRadius: BorderRadius.circular(16),
                      //         boxShadow: [
                      //           BoxShadow(
                      //             color: primary.withOpacity(0.3),
                      //             blurRadius: 15,
                      //             offset: const Offset(0, 8),
                      //           ),
                      //         ],
                      //       ),
                      //       child: const Icon(Icons.auto_awesome, color: Colors.white, size: 32),
                      //     ),
                      //     const SizedBox(height: 12),
                      //     Text(
                      //       "Aether",
                      //       style: TextStyle(
                      //         fontSize: 24,
                      //         fontWeight: FontWeight.w900,
                      //         color: primary,
                      //         letterSpacing: -0.5,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(height: 48),

                      // Content Header
                      Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: onSurface,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Enter your credentials to access your vault and activity.",
                        style: TextStyle(
                          fontSize: 16,
                          color: onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Email Field
                      Text(
                        "Email Address",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: onSurfaceVariant),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        onChanged: formController.updateEmail,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: onSurface),
                        decoration: InputDecoration(
                          hintText: "name@example.com",
                          hintStyle: TextStyle(color: onSurfaceVariant.withOpacity(0.4)),
                          prefixIcon: Icon(Icons.mail_outline, color: onSurfaceVariant, size: 20),
                          filled: true,
                          fillColor: surfaceContainerLow,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: primary, width: 1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Password Field
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Password",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: onSurfaceVariant),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Forgot Password Logic
                            },
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: primary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        onChanged: formController.updatePassword,
                        // obscureText: true,
                        obscureText: !formState.isPasswordVisible,
                        style: TextStyle(color: onSurface),
                        decoration: InputDecoration(
                          hintText: "••••••••",
                          hintStyle: TextStyle(color: onSurfaceVariant.withOpacity(0.4)),
                          prefixIcon: Icon(Icons.lock_outline, color: onSurfaceVariant, size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(
                              formState.isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: onSurfaceVariant,
                              size: 20,
                            ),
                            onPressed: () {
                              ref.read(loginFormProvider.notifier).togglePasswordVisibility();
                            },
                          ),
                          filled: true,
                          fillColor: surfaceContainerLow,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: primary, width: 1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (formState.error != null) ...[
              const SizedBox(height: 16),
              Text(
                formState.error!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
                      // Action Button
                      const SizedBox(height: 32),
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [primary, secondary],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: primary.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: 
                              formState.isSubmitting ? null : formController.submit
                            ,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                formState.isSubmitting ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) 
                   : const Text(
                                  "Sign In",
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Divider Logic
                      Row(
                        children: [
                          Expanded(child: Divider(color: surfaceContainerHighest, thickness: 1)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              "OR CONTINUE WITH",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: onSurfaceVariant.withOpacity(0.5),
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: surfaceContainerHighest, thickness: 1)),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Social Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: Colors.white,
                                side: BorderSide(color: outlineVariant.withOpacity(0.3)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {},
                              // Note: Replaced the image URL with a local icon for standard Flutter implementation. 
                              // Use Image.network() if you strictly need the URL.
                              icon: const Icon(Icons.g_mobiledata, color: Colors.black87, size: 24),
                              label: const Text("Google", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: Colors.white,
                                side: BorderSide(color: outlineVariant.withOpacity(0.3)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {},
                              icon: const Icon(Icons.facebook, color: Colors.black87, size: 24),
                              label: const Text("Facebook", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 48),

                      // Footer Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account? ", style: TextStyle(color: onSurfaceVariant, fontSize: 14)),
                          GestureDetector(
                            onTap: 
                              formState.isSubmitting ? null : onToggle
                            ,
                            child: Text(
                              "Sign Up",
                              style: TextStyle(color: primary, fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    
    );
  }
}