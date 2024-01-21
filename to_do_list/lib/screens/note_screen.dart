import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/services/get_note.dart';
import 'package:to_do_list/widgets/my_button.dart';
import 'package:to_do_list/widgets/my_textfield.dart';

NoteData noteModel = NoteData();

void main() {
  runApp(const NoteScreen(uid: ''));
}

class NoteScreen extends StatelessWidget {
  final String uid;
  const NoteScreen({super.key, required this.uid});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Eventos',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(uid:uid),
    );
  }
}

class MyHomePage extends StatefulWidget {
    final String uid;
  const MyHomePage({super.key, required this.uid});
  @override
  _MyHomePageState createState() => _MyHomePageState(uid);
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _nameTileController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  late CollectionReference usersCollection;
  final String uid;
  _MyHomePageState(this.uid);
  

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }


    Future crear() async {
    /*  try {
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
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }*/
      if (kDebugMode) {
        print(uid);
      }
   
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange, // Set background color to orange
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Text(
                  'Gestor de notas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: _nameTileController,
                  hintText: 'Ingresa el titulo de tu nota',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: _descriptionController,
                  hintText: 'Ingresa la información de tu nota',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: _dateController,
                  hintText: _dateController.text,
                  obscureText: false,
                  editable:false,
                ),
                const SizedBox(height: 10),
                MyButton(
                  onTap: crear,
                  buttonText: 'Agregar',
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
