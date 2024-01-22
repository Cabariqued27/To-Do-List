import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/models/note.dart';
import 'package:to_do_list/screens/add_note_screen.dart';
import 'package:to_do_list/services/get_note.dart';
import 'package:to_do_list/widgets/my_button.dart';

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
    _updateNotes(); // Llama a la función _updateNotes en initState
  }

  Future<void> _updateNotes() async {
    await noteModel.getNotesFromDB(uid);
    setState(() {}); // Actualiza el estado para reconstruir la interfaz con las nuevas notas
  }

  Future<void> _createNote() async {
    // Abre la pantalla para agregar una nueva nota
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddNoteScreen(uid: uid),
      ),
    );

    // Después de agregar una nota, actualiza la lista
    _updateNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
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
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: noteModel.notes.length,
                itemBuilder: (context, index) {
                  Note note = noteModel.notes[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text( note.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(note.description),
                          Text('Estado: ${note.status}'),
                          Text('Fecha: ${note.date}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNote,
        child: Icon(Icons.add),
      ),
    );
  }
}
