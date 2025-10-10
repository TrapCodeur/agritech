import 'package:agritech/auth/register.dart';
import 'package:agritech/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Si l'utilisateur est connecté, on va directement à HomePage
        if (snapshot.hasData) {
          return const HomePage();
        }

        // Sinon, on montre la page de connexion
        return const RegisterPage();
      },
    );
  }
}
