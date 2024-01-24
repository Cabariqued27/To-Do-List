import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_list/models/task.dart';
import 'package:to_do_list/screens/add_task_screen.dart';
import 'package:to_do_list/screens/update_task_screen.dart';
import 'package:to_do_list/services/get_note.dart';

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
  final TextEditingController _dateController = TextEditingController();
  late CollectionReference noteCollection;
  final String uid;
  _MyHomePageState(this.uid);

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    noteCollection = FirebaseFirestore.instance.collection('tasks');
    _gettingTasks();
  }

  Future<void> _gettingTasks() async {
    await taskModel.geTasksFromDB(uid);
    setState(() {});
  }

  Future<void> _editTask(task, uid) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateTaskScreen(uid: uid, task: task),
      ),
    );
    _gettingTasks();
  }

  Future<void> _createTask() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskScreen(uid: uid),
      ),
    );
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
                  return Dismissible(
                    key: Key(task
                        .id), // Usamos el ID como clave para el widget Dismissible
                    onDismissed: (direction) {
                      // Eliminamos la tarea de la base de datos
                      _deleteTask(task.id);
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerLeft,
                      child: const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(10), // Margen para el contorno
                      padding: const EdgeInsets.all(10), // Espaciado interno
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey, // Color del borde
                          width: 1, // Ancho del borde
                        ),
                        borderRadius:
                            BorderRadius.circular(8), // Radio de esquinas del contorno
                      ),
                      child: ListTile(
                        title: Text(
                          task.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold, // Texto en negrita
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                                height:
                                    5), // Espacio entre el título y la descripción
                            Text(
                              task.description,
                            ),
                            const SizedBox(
                                height:
                                    10), // Espacio entre la descripción y "Translated from Spanish By Google"
                            const Text(
                              'Translated from Spanish By Google',
                              style: TextStyle(
                                color: Colors
                                    .blue, // Ajusta el color según tus preferencias
                              ),
                            ),
                            const SizedBox(
                                height:
                                    5), // Espacio entre "Translated from Spanish By Google" y la traducción
                            Text(
                              task.traduccion,
                            ),
                            const SizedBox(
                                height:
                                    10), // Espacio entre la traducción y la fecha
                            Row(
                              children: [
                                const Icon(Icons.calendar_today,
                                    size: 16, color: Colors.grey),
                                const SizedBox(width: 5),
                                Text(
                                  'Fecha: ${task.date}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                                height: 10), // Espacio entre la fecha y el estado
                            Row(
                              children: [
                                Icon(Icons.check_circle,
                                    size: 16,
                                    color: task.status == 'Completado'
                                        ? Colors.green
                                        : Colors.red),
                                const SizedBox(width: 5),
                                Text(
                                  'Estado: ${task.status}',
                                  style: TextStyle(
                                    color: task.status == 'Completado'
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                                height: 10), // Espacio adicional al final
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _editTask(task.id, uid);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
       floatingActionButton: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'Create') {
            _createTask();
          } else if (value == 'Update') {
            _gettingTasks();_gettingTasks();
          }
        },
        itemBuilder: (BuildContext context) => [
          const PopupMenuItem<String>(
            value: 'Create',
            child: Icon(Icons.add),
          ),
          const PopupMenuItem<String>(
            value: 'Update',
            child: Icon(Icons.download_sharp),
          ),
        ],
        child: const FloatingActionButton(
          onPressed: null,
          child: Icon(Icons.toc_outlined),
        ),
      ),
    );
  }

  Future<void> _deleteTask(String taskId) async {
    await noteCollection.doc(taskId).delete();
    _gettingTasks();
  }
}
