import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_mortgage_calc/screens/home_page.dart';
import 'package:flutter_mortgage_calc/services/auth.dart';
import 'package:sign_in_button/sign_in_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _loginWithEmailPassword() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    final UserCredential? userCredential =
        await _authService.signInWithEmailPassword(email, password);

    if (userCredential != null) {
      // If login successful, navigate to the new screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(19, 48, 65, 1.0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _loginWithEmailPassword(),
              child: Text('Login with email and password'),
            ),
            const SizedBox(height: 20),
            SignInButton(Buttons.google, text: 'Sign in with Google',
                onPressed: () async {
              UserCredential? userCredential =
                  await _authService.signInWithGoogle();

              if (userCredential != null) {
                // If login successful, navigate to the new screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
  @override
void dispose() {
  _emailController.dispose();
  _passwordController.dispose();
  super.dispose();
}
}


