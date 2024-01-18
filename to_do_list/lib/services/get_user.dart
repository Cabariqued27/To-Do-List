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

  Future<void> getUsersFromCache() async {
    // Obtener referencia a un nodo específico en la base de datos
    final ref = FirebaseDatabase.instance.ref().child('Users');

    // Escuchar cambios en los datos del nodo (en tiempo real)
    ref.onValue.listen((user) {
      _users.clear();
      if (user.snapshot.exists) {
        final Map<dynamic, dynamic> data =
            user.snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) {
          String date = value['date'] ?? '';
          String description = value['description'] ?? '';
          String name = value['name'] ?? '';

          print('User ID: $key');
          print('Date: $date');
          print('Description: $description');
          print('Name: $name');
          UserM newUser = UserM(
            id:key,
            name: name,
            description: description,
            date: date,
          );
          addUser(newUser);
        });
      } else {
        print('No data available.');
      }
    });
  }
}
