import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/screens/auth_screen.dart';
import 'package:to_do_list/screens/signup_screen.dart';
import 'package:to_do_list/widgets/my_button.dart';
import 'package:to_do_list/widgets/my_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // text editing controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void signUserIn() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // pop the loading circle
      Navigator.pop(context);

      // Navigate to AuthPage after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthScreen()),
      );
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);
      // WRONG EMAIL
      if (e.code == 'user-not-found') {
        // show error to user
        wrongEmailMessage();
      }
      // WRONG PASSWORD
      else if (e.code == 'wrong-password') {
        // show error to user
        wrongPasswordMessage();
      }
    }
  }

  // wrong email message popup
  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Color.fromARGB(
              255, 223, 218, 217), // Set background color to deep orange
          title: Center(
            child: Text(
              'Correo electrónico incorrecto',
              style: TextStyle(
                  color: Color.fromARGB(
                      255, 109, 53, 53)), // Set text color to white
            ),
          ),
        );
      },
    );
  }

  // wrong password message popup
  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Color.fromARGB(255, 30, 23, 23), // Set background color to deep orange
          title: Center(
            child: Text(
              'Contraseña incorrecta',
              style: TextStyle(
                  color: Color.fromARGB(255, 184, 174, 174)), // Set text color to white
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255), // Set background color to orange
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                // welcome back, you've been missed!
                const Text(
                  'Bienvenido',
                  style: TextStyle(
                    color: Color.fromARGB(255, 48, 89, 161), // Set text color to white
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 30),

                // email textfield
                MyTextField(
                  controller: _emailController,
                  labelText: 'Correo electrónico',
                  obscureText: false, readOnly: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                MyTextField(
                  controller: _passwordController,
                  labelText: 'Contraseña',
                  obscureText: true, readOnly: false,
                ),

                

                const SizedBox(height: 25),

                // sign in button
                MyButton(
                  onTap: signUserIn, buttonText: 'Sign In',
                ),

                const SizedBox(height: 50),
                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '¿No está afiliado?',
                      style: TextStyle(
                        color: Color.fromARGB(255, 48, 89, 161),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        // Navegar hacia la página de registro cuando se haga clic en el texto
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(showLoginPage: () {  },
                
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Regístrese ahora',
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