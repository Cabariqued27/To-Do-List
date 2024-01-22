import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/models/note.dart';
import 'package:to_do_list/screens/add_note_screen.dart';
import 'package:to_do_list/services/get_note.dart';
import 'package:to_do_list/widgets/dropdown.dart';
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
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  late CollectionReference noteCollection;
  final String uid;
  _MyHomePageState(this.uid);

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    noteCollection = FirebaseFirestore.instance.collection('notes');
    print(noteModel.getNotesFromDB(uid));
    noteModel.printNotes();
  }

  Future Update() async {
    print(noteModel.getNotesFromDB(uid));
    noteModel.printNotes();
  }

  Future Create() async {
    return AddNoteScreen(uid: uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Text(
                  'Tus Notas',
                  style: TextStyle(
                    color: Color.fromARGB(255, 48, 89, 161),
                    fontSize: 16,
                  ),
                ),
                MyButton(
                  onTap: Update,
                  buttonText: 'Actualizar',
                ),
                const SizedBox(height: 20), // Añade espacio entre los botones
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddNoteScreen(uid: uid),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 255, 255,
                        255), backgroundColor: const Color.fromARGB(
                        255, 48, 89, 161), // Cambia el color del texto a blanco
                    padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 32), // Ajusta el tamaño del botón
                  ),
                  child: const Text('Agregar nota',
                      style: TextStyle(
                          fontSize: 18)), // Ajusta el tamaño del texto
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
