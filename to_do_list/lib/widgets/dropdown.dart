import 'package:flutter/material.dart';

const List<String> list = <String>['Pendiente', 'Completado'];

class DropdownMenuApp extends StatelessWidget {
  const DropdownMenuApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(title: const Text('DropdownMenu Sample')),
        body: Center(
          child: DropdownMenuExample(onStatusSelected: (String ) {  },), // Remove 'const' here
        ),
      ),
    );
  }
}

class DropdownMenuExample extends StatefulWidget {
  final Function(String) onStatusSelected;

  const DropdownMenuExample({Key? key, required this.onStatusSelected}) : super(key: key);

  @override
  State<DropdownMenuExample> createState() => _DropdownMenuExampleState();
}

class _DropdownMenuExampleState extends State<DropdownMenuExample> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
          widget.onStatusSelected(dropdownValue);
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
