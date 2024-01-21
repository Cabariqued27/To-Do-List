import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/models/user.dart';
import 'package:to_do_list/widgets/my_button.dart';
import 'package:to_do_list/widgets/my_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback showLoginPage;

  const RegisterScreen({
    Key? key,
    required this.showLoginPage,
  }) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final _nameController = TextEditingController();
  late CollectionReference usersCollection;

  @override
  void initState() {
    super.initState();
    usersCollection = FirebaseFirestore.instance.collection('users');
    // Set default values for each controller
    _emailController.text = 'default@gmail.com';
    _passwordController.text = '123456';
    _confirmpasswordController.text = '123456';
    _nameController.text = 'Default Name';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future signUp() async {
    if (passwordConfirmed()) {
      try {
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Get the UID from the UserCredential
        final String uid = credential.user!.uid;

        UserM newUser = UserM(
          name: _nameController.text.trim(),
        );

        // Save the user details with UID as ID in the database
        await usersCollection.doc(uid).set({
          'Name': newUser.name,
          // Add other fields as needed
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          if (kDebugMode) {
            print('The password provided is too weak.');
          }
        } else if (e.code == 'email-already-in-use') {
          if (kDebugMode) {
            print('The account already exists for that email.');
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
    Navigator.pop(context);
  }

  bool passwordConfirmed() {
    return _passwordController.text.trim() ==
        _confirmpasswordController.text.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Text(
                  'Registro de Voluntarios',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: _emailController,
                  hintText: 'Correo electrónico',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: _passwordController,
                  hintText: 'Contraseña',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: _confirmpasswordController,
                  hintText: 'Confirmar Contraseña',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: _nameController,
                  hintText: 'Nombre',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyButton(
                  onTap: signUp,
                  buttonText: 'Sing Up',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}