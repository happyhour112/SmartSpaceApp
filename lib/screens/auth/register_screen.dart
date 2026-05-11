import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/auth/my_button.dart';
import '../../widgets/auth/my_text_form_field.dart';
import '../../widgets/auth/square_tile.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
    required this.onTap,
  });

  final void Function() onTap;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final countryController = TextEditingController();
  final organizationController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    countryController.dispose();
    organizationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void showMessage(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
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

  Future<void> signUp() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = credential.user;

      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-null',
          message: 'User account could not be created.',
        );
      }

      await user.updateDisplayName(nameController.text.trim());

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'displayName': nameController.text.trim(),
        'email': emailController.text.trim(),
        'country': countryController.text.trim(),
        'organization': organizationController.text.trim(),
        'role': 'student',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // No manual navigation is needed.
      // AuthGate detects the logged-in Firebase user and opens DashboardScreen.
    } on FirebaseAuthException catch (e) {
      showMessage('Registration Failed', e.message ?? 'Registration failed.');
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
                  'Let\'s create an account!',
                  style: TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 25),
                MyTextFormField(
                  controller: nameController,
                  hintText: 'Full Name',
                  obscureText: false,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Name cannot be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                MyTextFormField(
                  controller: countryController,
                  hintText: 'Country',
                  obscureText: false,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Country cannot be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                MyTextFormField(
                  controller: organizationController,
                  hintText: 'Organization / Campus',
                  obscureText: false,
                  validator: (value) {
                    return null;
                  },
                ),
                const SizedBox(height: 10),
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
                MyTextFormField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Confirm password cannot be empty';
                    }
                    if (value != passwordController.text) {
                      return 'Password does not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),
                isLoading
                    ? const CircularProgressIndicator()
                    : MyButton(
                        buttonText: 'Sign Up',
                        onTap: signUp,
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
                    const Text('Already have an account?'),
                    const SizedBox(width: 4),
                    TextButton(
                      onPressed: widget.onTap,
                      child: const Text(
                        'Login now',
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
