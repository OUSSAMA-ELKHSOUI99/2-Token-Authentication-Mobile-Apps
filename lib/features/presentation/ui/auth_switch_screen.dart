// presentation/ui/auth_switch_screen.dart
import 'package:authentication/features/presentation/ui/loging_screen.dart';
import 'package:authentication/features/presentation/ui/registration_screen.dart';
import 'package:flutter/material.dart';
// import 'login_screen.dart';
// import 'registration_screen.dart';

class AuthSwitchScreen extends StatefulWidget {
  const AuthSwitchScreen({super.key});

  @override
  State<AuthSwitchScreen> createState() => _AuthSwitchScreenState();
}

class _AuthSwitchScreenState extends State<AuthSwitchScreen> {
  bool _showLogin = true;

  void _toggleScreen() {
    setState(() {
      _showLogin = !_showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Pass the toggle function to both screens so the user can switch!
    if (_showLogin) {
      return LoginScreen(onToggle: _toggleScreen);
    } else {
      return RegistrationScreen(onToggle: _toggleScreen);
    }
  }
}