import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/models/note.dart';
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
      home: MyHomePage(uid: uid),
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
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  late CollectionReference noteCollection;
  final String uid;
  _MyHomePageState(this.uid);

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    noteCollection = FirebaseFirestore.instance.collection('notes');
  }

  Future crear() async {
    Note newNote = Note(
      idu: uid,
      title: _nameTileController.text.trim(),
      description: _descriptionController.text.trim(),
      status: _nameTileController.text.trim(),
      date: _dateController.text.trim(),
    );
    await noteCollection.doc().set({
      'Idu': newNote.idu,
      'Title': newNote.title,
      'Description': newNote.description,
      'Status': newNote.status,
      'Date': newNote.date,
    });
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
                  readOnly: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: _descriptionController,
                  hintText: 'Ingresa la descripción',
                  obscureText: false,
                  readOnly: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: _statusController,
                  hintText: 'Ingresa el estado',
                  obscureText: false,
                  readOnly: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: _dateController,
                  hintText: _dateController.text,
                  obscureText: false,
                  readOnly: true,
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
