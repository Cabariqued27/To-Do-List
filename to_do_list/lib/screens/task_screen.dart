import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/models/task.dart';
import 'package:to_do_list/screens/add_task_screen.dart';
import 'package:to_do_list/screens/update_task_screen.dart';
import 'package:to_do_list/services/get_note.dart';
import 'package:to_do_list/widgets/my_button.dart';

TaskData taskModel = TaskData();

void main() {
  runApp(const TaskScreen(uid: ''));
}

class TaskScreen extends StatelessWidget {
  final String uid;
  const TaskScreen({super.key, required this.uid});

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
    noteCollection = FirebaseFirestore.instance.collection('tasks');
    _gettingTasks(); // Llama a la función _gettingTasks en initState
  }

  Future<void> _gettingTasks() async {
    await taskModel.geTasksFromDB(uid);
    setState(
        () {}); // Actualiza el estado para reconstruir la interfaz con las nuevas notas
  }

  Future<void> _editTask(task,uid) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateTaskScreen(uid: uid, task: task),
      ),
    );

    // Después de agregar una nota, actualiza la lista
    _gettingTasks();// Actualiza el estado para reconstruir la interfaz con las nuevas notas
  }

  Future<void> _createTask() async {
    // Abre la pantalla para agregar una nueva nota
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskScreen(uid: uid),
      ),
    );

    // Después de agregar una nota, actualiza la lista
    _gettingTasks();
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
              'Tus Tareas',
              style: TextStyle(
                color: Color.fromARGB(255, 48, 89, 161),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: taskModel.tasks.length,
                itemBuilder: (context, index) {
                  Task task = taskModel.tasks[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(task.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(task.description),
                          Text('Traducción: ${task.traduccion}'),
                          Text('Estado: ${task.status}'),
                          Text('Fecha: ${task.date}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Aquí puedes agregar la lógica para editar la tarea
                          print(task.id);
                          print(uid);
                          _editTask(task.id,uid);
                          
                        },
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
        onPressed: _createTask,
        child: Icon(Icons.add),
      ),
    );
  }
}
