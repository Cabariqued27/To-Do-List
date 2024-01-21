import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/firebase_options.dart';
import 'package:to_do_list/screens/login_screen.dart';
import 'package:to_do_list/screens/add_note_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  try {
    final db = FirebaseFirestore.instance;
    if (kDebugMode) {
      print("Firebase se ha inicializado correctamente: $db");
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error al inicializar Firebase: $e");
    }
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => noteModel),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.white),
        home: const LoginScreen(),
      ),
    );
  }
}
