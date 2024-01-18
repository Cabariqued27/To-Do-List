import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../models/note.dart';

class NoteData extends ChangeNotifier {
  List<Note> _notes = [];
  List<Note> get notes => _notes;

  Future<void> addNote(Note note) async {
    _notes.add(note);
    //await Note.save();
    print(note.id);
    notifyListeners();
  }

  Future<void> getNotesFromCache() async {
    // Obtener referencia a un nodo específico en la base de datos
    final ref = FirebaseDatabase.instance.ref().child('Notes');

    // Escuchar cambios en los datos del nodo (en tiempo real)
    ref.onValue.listen((note) {
      _notes.clear();
      if (Note.snapshot.exists) {
        final Map<dynamic, dynamic> data =
            Note.snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) {
          String date = value['date'] ?? '';
          String description = value['description'] ?? '';
          String name = value['name'] ?? '';

          print('Note ID: $key');
          print('Date: $date');
          print('Description: $description');
          print('Name: $name');
          Note newNote = Note(
            id:key,
            name: name,
            description: description,
            date: date,
          );
          addNote(newNote);
        });
      } else {
        print('No data available.');
      }
    });
  }
}
