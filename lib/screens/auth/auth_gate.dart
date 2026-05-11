import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../screens/dashboard_screen.dart';
import '../../state/device_provider.dart';
import 'login_or_register_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        final user = snapshot.data;
        if (user == null) return const LoginOrRegisterScreen();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<DeviceProvider>().startForUser(user.uid);
        });
        return const DashboardScreen();
      },
    );
  }
}
