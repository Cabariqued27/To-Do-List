import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/models/task.dart';
import 'package:to_do_list/screens/task_screen.dart';
import 'package:to_do_list/services/get_note.dart';
import 'package:to_do_list/widgets/dropdown.dart';
import 'package:to_do_list/widgets/my_button.dart';
import 'package:to_do_list/widgets/my_textfield.dart';

TaskData taskModel = TaskData();

void main() {
  runApp(const UpdateTaskScreen(
    uid: '',
    task: '',
  ));
}

class UpdateTaskScreen extends StatelessWidget {
  final String uid;
  final String task;
  const UpdateTaskScreen({super.key, required this.uid, required this.task});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Actualizar estado de la tarea',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(uid: uid, task: task),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String uid;
  final String task;
  const MyHomePage({super.key, required this.uid, required this.task});
  @override
  _MyHomePageState createState() => _MyHomePageState(uid, task);
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  late CollectionReference taskCollection;
  final String uid;
  final String task;
  _MyHomePageState(this.uid, this.task);
  String selectedStatus = 'Pendiente';

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    getData();
  }

  Future getData() async {
    // Obtener la referencia de la colección "tasks" en Firestore
    CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');

    try {
      // Obtener el documento de la tarea con el ID almacenado en la variable "task"
      DocumentSnapshot taskSnapshot = await tasks.doc(task).get();

      // Verificar si el documento existe antes de intentar acceder a los datos
      if (taskSnapshot.exists) {
        // Obtener los datos de la tarea y actualizar los controladores
        Map<String, dynamic> taskData =
            taskSnapshot.data() as Map<String, dynamic>;
        _titleController.text = taskData['Title'] ?? '';
        _statusController.text = taskData['Status'] ?? '';
        _descriptionController.text = taskData['Description'] ?? '';
        print(_titleController.text);
        print(_descriptionController.text);
        print(_statusController.text);
        // Puedes agregar más campos según la estructura de tu modelo de tarea
      } else {
        // Manejar el caso en el que la tarea no existe
        print('La tarea con ID $task no existe.');
      }
    } catch (error) {
      // Manejar cualquier error que pueda ocurrir durante la consulta a Firestore
      print('Error al obtener la tarea: $error');
    }
  }

  Future Update() async {
    // Obtener la referencia de la colección "tasks" en Firestore
    CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');

    try {
      await tasks.doc(task).update({
        'Status': selectedStatus,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Estado actualizado con éxito'),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (error) {
      print('Error al actualizar la tarea: $error');
    }
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskScreen(uid: uid),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
          255, 255, 255, 255), // Set background color to orange
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Text(
                  'Actualizar tarea',
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
                  readOnly: true,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: _descriptionController,
                  labelText: 'Descripción',
                  obscureText: false,
                  readOnly: true,
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
                  onTap: Update,
                  buttonText: 'Actualizar',
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
