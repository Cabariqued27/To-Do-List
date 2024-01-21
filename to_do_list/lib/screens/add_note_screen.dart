import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/models/note.dart';
import 'package:to_do_list/services/get_note.dart';
import 'package:to_do_list/widgets/dropdown.dart';
import 'package:to_do_list/widgets/my_button.dart';
import 'package:to_do_list/widgets/my_textfield.dart';

NoteData noteModel = NoteData();

void main() {
  runApp(const AddNoteScreen(uid: ''));
}

class AddNoteScreen extends StatelessWidget {
  final String uid;
  const AddNoteScreen({super.key, required this.uid});

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
  TextEditingController _statusController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  late CollectionReference noteCollection;
  final String uid;
  _MyHomePageState(this.uid);
  String selectedStatus = '';

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
      status: selectedStatus,
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
      backgroundColor:
          Color.fromARGB(255, 255, 255, 255), // Set background color to orange
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
                    color: Color.fromARGB(255, 48, 89, 161),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: _nameTileController,
                  labelText: 'Título',
                  obscureText: false,
                  readOnly: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: _descriptionController,
                  labelText: 'Descripción',
                  obscureText: false,
                  readOnly: false,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Estado',
                  style: TextStyle(
                    color: Color.fromARGB(255, 48, 89, 161),
                    fontSize: 16,
                  ),
                ),
                DropdownMenuExample(
                  onStatusSelected: (String status) {
                    setState(() {
                      selectedStatus =
                          status; // Actualizar la variable con el valor seleccionado
                    });
                  },
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: _dateController,
                  obscureText: false,
                  readOnly: true,
                  labelText: '',
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
