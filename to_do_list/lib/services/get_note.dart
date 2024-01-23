import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/task.dart';

class TaskData extends ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  Future<void> addNote(Task task) async {
    _tasks.add(task);
    //await Note.save();
    if (kDebugMode) {
      print(task.idu);
    }
    notifyListeners();
  }

  Future<void> geTasksFromDB(uid) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance.collection("tasks").where("Idu", isEqualTo: uid).get();

      print("Successfully completed");

      // Limpiar la lista antes de agregar nuevas notas
      _tasks.clear();

      for (var docSnapshot in querySnapshot.docs) {
        print('${docSnapshot.id} => ${docSnapshot.data()}');
        // Crear instancias de Note y agregarlas a la lista _tasks
        Task note = Task(
          // Aquí debes mapear los campos según la estructura de tu modelo Note
          id: docSnapshot.id,
          idu: docSnapshot.data()["Idu"],
          title:  docSnapshot.data()["Title"],
          description:  docSnapshot.data()["Description"],
          traduccion:  docSnapshot.data()["translatedDescription"],
          status:  docSnapshot.data()["Status"],
          date:  docSnapshot.data()["Date"],

          // Otros campos...
        );
        _tasks.add(note);
      }

      // Notificar a los listeners que los datos han sido actualizados
      notifyListeners();
    } catch (e) {
      print("Error completing: $e");
    }
  }
  void printtasks() {
    for (var note in _tasks) {
      print("ID: ${note.id}");
      print("IDu: ${note.idu}");
      print("Title: ${note.title}");
      print("Description: ${note.description}");
      print("Traducción: ${note.traduccion}");
      print("Status: ${note.status}");
      print("Date: ${note.date}");
      // Puedes agregar más campos según la estructura de tu modelo Note
      print("---------------");
    }
  }
}
