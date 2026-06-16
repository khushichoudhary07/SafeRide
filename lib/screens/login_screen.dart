import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void login(BuildContext context) async {
    var user = await AuthService.signInWithGoogle();

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: Center(
        child: ElevatedButton(
          onPressed: () => login(context),
          child: const Text("Sign in with Google"),
        ),
      ),
    );
  }
}