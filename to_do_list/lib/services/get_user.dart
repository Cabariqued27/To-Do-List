import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../models/User.dart';

class UserData extends ChangeNotifier {
  List<UserM> _users = [];
  List<UserM> get users => _users;

  Future<void> addUser(UserM user) async {
    _users.add(user);
    //await User.save();
    print(user.id);
    notifyListeners();
  }

    Future<void> getNotesFromDB() async {
    await FirebaseFirestore.instance.collection("users").get().then((event) {
      for (var doc in event.docs) {
        UserM note = UserM(
          id: doc.id,
          name: doc['name'],
        );

        _users.add(note);
      }
      notifyListeners();
    });
  }
}
