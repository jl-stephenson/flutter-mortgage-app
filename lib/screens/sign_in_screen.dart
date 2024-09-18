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
  final _formKey = GlobalKey<FormState>();
  final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

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

  Future<void> _registerWithEmailPassword() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    final UserCredential? userCredential =
        await _authService.registerWithEmailPassword(email, password);

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
      backgroundColor: const Color.fromRGBO(228, 244, 253, 1.0),
      body: Center(
        child: Card(
          elevation: 4,
          color: Colors.white,
          child: Form(
            key: _formKey,
            child: Container(
              width: 400,
              height: 500,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!_emailRegex.hasMatch(value)) {
                          return 'Please enter valid email address';
                        }
                        return null;
                      },
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        } else if (value.length < 6 || value.length > 20) {
                          return 'Passwords must be 6 - 20 characters';
                        }
                        return null;
                      },
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          _loginWithEmailPassword();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(19, 48, 65, 1.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 20.0),
                      ),
                      child: const Text(
                        'Login with email and password',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          _registerWithEmailPassword();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(19, 48, 65, 1.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 20.0),
                      ),
                      child: const Text(
                        'Register with email and password',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SignInButton(Buttons.googleDark,
                        text: 'Sign in with Google', onPressed: () async {
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
            ),
          ),
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
