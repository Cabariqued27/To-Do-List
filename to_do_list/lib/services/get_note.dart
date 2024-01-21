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
      print(note.id);
    }
    notifyListeners();
  }

  Future<void> getNotesFromDB() async {
    await FirebaseFirestore.instance.collection("Notes").get().then((event) {
      for (var doc in event.docs) {
        Note note = Note(
          id: doc.id,
          title: doc['title'],
          description: doc['description'], 
        );

        _notes.add(note);
      }
      notifyListeners();
    });
  }
}
