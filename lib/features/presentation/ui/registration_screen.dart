import 'dart:ui';

import 'package:authentication/features/const/const.dart';
import 'package:authentication/features/presentation/controllers/registration_form_controller.dart';
import 'package:flutter/gestures.dart';
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
      // body: Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: Column(
      //     children: [
      //       TextField(
      //         onChanged: formController.updateEmail, // Update state on every keystroke
      //         decoration: InputDecoration(
      //           labelText: 'Email',
      //           errorText: formState.emailError, // UI automatically shows the error
      //         ),
      //       ),
      //       TextField(
      //         onChanged: formController.updatePassword,
      //         obscureText: true,
      //         decoration: InputDecoration(
      //           labelText: 'Password',
      //           errorText: formState.passwordError,
      //         ),
      //       ),
      //       const SizedBox(height: 20),
      //       ElevatedButton(
      //         onPressed: formState.isSubmitting ? null : formController.submit,
      //         child: formState.isSubmitting 
      //             ? const CircularProgressIndicator() 
      //             : const Text('Register'),
      //       ),
      //       const SizedBox(height: 16),
            
      //       // The magic button that switches to the Registration Screen
      //       TextButton(
      //         onPressed: formState.isSubmitting ? null : onToggle,
      //         child: const Text('Already have an account? LogIn'),
      //       )
      //     ],
      //   ),
      // ),
      backgroundColor: background,
      extendBodyBehindAppBar: true, // Allows the body to flow under the transparent app bar
      // appBar: AppBar(
      //   backgroundColor: background.withOpacity(0.7),
      //   elevation: 0,
      //   scrolledUnderElevation: 0,
      //   // Glassmorphism effect for the AppBar
      //   flexibleSpace: ClipRect(
      //     child: BackdropFilter(
      //       filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
      //       child: Container(color: Colors.transparent),
      //     ),
      //   ),
      //   leading: Padding(
      //     padding: const EdgeInsets.only(left: 8.0),
      //     child: IconButton(
      //       icon: Icon(Icons.arrow_back, color: primary),
      //       onPressed: () => Navigator.of(context).pop(),
      //       splashRadius: 24,
      //     ),
      //   ),
      //   title: Text(
      //     "Aether",
      //     style: TextStyle(
      //       fontSize: 24,
      //       fontWeight: FontWeight.w900,
      //       color: primary,
      //       letterSpacing: -0.5,
      //     ),
      //   ),
      //   centerTitle: true,
      // ),
      body: Stack(
        children: [
          // Background Decorative Elements (Asymmetric)
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 256,
              height: 256,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: secondary.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -100,
            child: Container(
              width: 384,
              height: 384,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primary.withOpacity(0.1),
              ),
            ),
          ),
          // Blur layer
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(color: Colors.transparent),
            ),
          ),

          // Main Content Canvas
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Hero Section
                      Column(
                        children: [
                          // Container(
                          //   padding: const EdgeInsets.all(12),
                          //   margin: const EdgeInsets.only(bottom: 24),
                          //   decoration: BoxDecoration(
                          //     color: surfaceContainerHigh,
                          //     borderRadius: BorderRadius.circular(24),
                          //   ),
                          //   child: Icon(Icons.auto_awesome, color: primary, size: 32),
                          // ),
                          Text(
                            "Create Account",
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              color: onSurface,
                              letterSpacing: -0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Join the ethereal professional network.",
                            style: TextStyle(fontSize: 16, color: onSurfaceVariant),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),

                      // Registration Form
                      // Full Name
                      _buildLabel("Full Name"),
                      _buildTextField(
                        hintText: "John Doe",
                        icon: Icons.person_outline,
                        keyboardType: TextInputType.name,
                        onChanged: formController.updateFullName
                      ),
                      const SizedBox(height: 24),

                      // Email
                      _buildLabel("Email Address"),
                      _buildTextField(
                        hintText: "hello@aether.com",
                        icon: Icons.mail_outline,
                        keyboardType: TextInputType.emailAddress,
                        errorText: formState.emailError,
                        onChanged: formController.updateEmail,
                      ),
                      const SizedBox(height: 24),

                      // Password
                      _buildLabel("Password"),
                      _buildPasswordField(
                        hintText: "••••••••",
                        icon: Icons.lock_outline,
                        isVisible: formState.isPasswordVisible,
                        onVisibilityToggle: () {
                          ref.read(registrationFormProvider.notifier).togglePasswordVisibility();
                        },
                        errorText: formState.passwordError,
                        onChanged: formController.updatePassword,
                      ),
                      const SizedBox(height: 24),

                      // Confirm Password
                      _buildLabel("Confirm Password"),
                      _buildTextField(
                        hintText: "••••••••",
                        icon: Icons.verified_user_outlined,
                        obscureText: true, // Usually always hidden, or tie to another state
                        onChanged: formController.updateConfirmPassword
                      ),
                      const SizedBox(height: 24),

                      // Terms and Conditions
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: formState.agreedToTerms,
                              onChanged: (value) {
                                ref.read(registrationFormProvider.notifier).toggleAgreedToTerms();
                              },
                              activeColor: secondary,
                              side: BorderSide(color: outlineVariant, width: 2),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(color: onSurfaceVariant, fontSize: 14, height: 1.4),
                                children: [
                                  const TextSpan(text: "I agree to the "),
                                  TextSpan(
                                    text: "Terms and Conditions",
                                    style: TextStyle(color: primary, fontWeight: FontWeight.w600),
                                    recognizer: TapGestureRecognizer()..onTap = () {},
                                  ),
                                  const TextSpan(text: " and "),
                                  TextSpan(
                                    text: "Privacy Policy",
                                    style: TextStyle(color: primary, fontWeight: FontWeight.w600),
                                    recognizer: TapGestureRecognizer()..onTap = () {},
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Sign Up Button
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [primary, primaryContainer],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: primary.withOpacity(0.25),
                              blurRadius: 48,
                              offset: const Offset(0, 24),
                              spreadRadius: -12,
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(24),
                            onTap: () {
                              // Sign Up Logic
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Sign Up",
                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward, color: Colors.white, size: 24),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Divider (Tonal Shift)
                      Center(
                        child: Text(
                          "SECURE REGISTRATION",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: onSurfaceVariant.withOpacity(0.4),
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Footnote
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account? ", style: TextStyle(color: onSurfaceVariant, fontSize: 14)),
                          GestureDetector(
                            onTap: formState.isSubmitting ? null : onToggle,
                            child: Text(
                              "Sign In",
                              style: TextStyle(color: secondary, fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
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

  // Helper method for labels
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: onSurface),
      ),
    );
  }

  // Helper method for standard text fields
  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged, // <--- Fixed to accept a String
    String? errorText,
  }) {
    return TextField(
      onChanged: onChanged,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(color: onSurface),
      decoration: InputDecoration(
        errorText: errorText,
        hintText: hintText,
        hintStyle: TextStyle(color: onSurfaceVariant.withOpacity(0.5)),
        prefixIcon: Icon(icon, color: onSurfaceVariant, size: 22),
        filled: true,
        fillColor: surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(vertical: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primary, width: 1),
        ),
      ),
    );
  }

  // Helper method specifically for the password field with the toggle button
  Widget _buildPasswordField({
    required String hintText,
    required IconData icon,
    required bool isVisible,
    required VoidCallback onVisibilityToggle,
    ValueChanged<String>? onChanged, // <--- Fixed to accept a String
    String? errorText,
  }) {
    return TextField(
      onChanged: onChanged,
      obscureText: !isVisible,
      style: TextStyle(color: onSurface),
      decoration: InputDecoration(
        errorText: errorText,
        hintText: hintText,
        hintStyle: TextStyle(color: onSurfaceVariant.withOpacity(0.5)),
        prefixIcon: Icon(icon, color: onSurfaceVariant, size: 22),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: onSurfaceVariant,
              size: 22,
            ),
            onPressed: onVisibilityToggle,
            splashRadius: 24,
          ),
        ),
        filled: true,
        fillColor: surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(vertical: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primary, width: 1),
        ),
      ),
    );
  }
}