import 'package:cloud_firestore/cloud_firestore.dart';
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
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
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
  // Validar que los campos de título y descripción no estén vacíos
  if (_titleController.text.trim().isEmpty || _descriptionController.text.trim().isEmpty) {
    // Muestra un mensaje de error si alguno de los campos está vacío
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Por favor, completa los campos de título y descripción.'),
        duration: Duration(seconds: 3),
      ),
    );
    return; // Salir de la función si hay campos vacíos
  }

  // Continuar con la creación de la nota si los campos no están vacíos
  Note newNote = Note(
    idu: uid,
    title: _titleController.text.trim(),
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

  // Muestra el mensaje después de agregar la nota
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Nota agregada con éxito'),
      duration: Duration(seconds: 3),
    ),
  );

  // Limpiar los controladores después de agregar la nota
  _titleController.clear();
  _descriptionController.clear();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 255, 255, 255), // Set background color to orange
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
                  controller: _titleController,
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
