import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/screens/login_screen.dart';
import 'package:to_do_list/screens/note_screen.dart';


class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            User? user = snapshot.data;
            return TaskScreen(uid: user?.uid ?? ''); // Pasa la uid a NoteScreen
          }

          // user is NOT logged in
          else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}