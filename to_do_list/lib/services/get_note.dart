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

  Future<void> getNotesFromDB() async {
    FirebaseFirestore.instance.collection("notes").where("Idu", isEqualTo: "GSaTsnC0mAbo1HUEqy53xAEyJbM2").get().then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          print('${docSnapshot.id} => ${docSnapshot.data()}');
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }
}
