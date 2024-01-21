import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/services/get_note.dart';


NoteData noteModel = NoteData();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Eventos',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _eventNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.orange,
          width: 10.0,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Gestión de Eventos'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.orange,
                          width: 3.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextFormField(
                        controller: _eventNameController,
                        decoration:
                            InputDecoration(labelText: 'Nombre del Evento'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor, ingresa un nombre para el evento.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.orange,
                          width: 3.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                            labelText: 'Descripción del Evento'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor, ingresa una descripción para el evento.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.orange,
                          width: 3.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextFormField(
                        controller: _dateController,
                        decoration:
                            InputDecoration(labelText: 'Fecha del Evento'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor, ingresa una fecha para el evento.';
                          }
                          return null;
                        },
                        readOnly: true,
                      ),
                    ),
                    
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Eventos Registrados:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
