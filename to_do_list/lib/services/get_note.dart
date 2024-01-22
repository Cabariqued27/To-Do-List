import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/note.dart';

class NoteData extends ChangeNotifier {
  List<Note> _notes = [];
  List<Note> get notes => _notes;

  Future<void> addNote(Note note) async {
    _notes.add(note);
    //await Note.save();
    if (kDebugMode) {
      print(note.idu);
    }
    notifyListeners();
  }

  Future<void> getNotesFromDB(uid) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance.collection("notes").where("Idu", isEqualTo: uid).get();

      print("Successfully completed");

      // Limpiar la lista antes de agregar nuevas notas
      _notes.clear();

      for (var docSnapshot in querySnapshot.docs) {
        print('${docSnapshot.id} => ${docSnapshot.data()}');
        // Crear instancias de Note y agregarlas a la lista _notes
        Note note = Note(
          // Aquí debes mapear los campos según la estructura de tu modelo Note
          id: docSnapshot.id,
          idu: docSnapshot.data()["Idu"],
          title:  docSnapshot.data()["Title"],
          description:  docSnapshot.data()["Description"],
          status:  docSnapshot.data()["Status"],
          date:  docSnapshot.data()["Date"],

          // Otros campos...
        );
        _notes.add(note);
      }

      // Notificar a los listeners que los datos han sido actualizados
      notifyListeners();
    } catch (e) {
      print("Error completing: $e");
    }
  }
  void printNotes() {
    for (var note in _notes) {
      print("ID: ${note.id}");
      print("IDu: ${note.idu}");
      print("Title: ${note.title}");
      print("Description: ${note.description}");
      print("Status: ${note.status}");
      print("Date: ${note.date}");
      // Puedes agregar más campos según la estructura de tu modelo Note
      print("---------------");
    }
  }
}
