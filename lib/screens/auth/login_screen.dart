import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/auth/my_button.dart';
import '../../widgets/auth/my_text_form_field.dart';
import '../../widgets/auth/square_tile.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.onTap,
  });

  final void Function() onTap;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Login Failed'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> signIn() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // No manual navigation is needed.
      // AuthGate listens to FirebaseAuth authStateChanges()
      // and will automatically show DashboardScreen after login.
    } on FirebaseAuthException catch (e) {
      showErrorMessage(e.message ?? 'Incorrect email or password.');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Center(
                  child: Icon(Icons.lock, size: 100),
                ),
                const SizedBox(height: 50),
                const Text(
                  'Welcome back!',
                  style: TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 25),
                MyTextFormField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email cannot be empty';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                MyTextFormField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Password cannot be empty';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.only(right: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Forgot Password?'),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                isLoading
                    ? const CircularProgressIndicator()
                    : MyButton(
                        buttonText: 'Sign In',
                        onTap: signIn,
                      ),
                const SizedBox(height: 50),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(child: Divider(thickness: 0.5)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text('Or continue with'),
                      ),
                      Expanded(child: Divider(thickness: 0.5)),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(imagePath: 'assets/images/google.png'),
                    SizedBox(width: 25),
                    SquareTile(imagePath: 'assets/images/apple.png'),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Not a member?'),
                    const SizedBox(width: 4),
                    TextButton(
                      onPressed: widget.onTap,
                      child: const Text(
                        'Register now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
