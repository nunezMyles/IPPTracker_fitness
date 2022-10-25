import 'package:flutter/material.dart';

class AddRunScreen extends StatefulWidget {
  const AddRunScreen({Key? key}) : super(key: key);

  @override
  State<AddRunScreen> createState() => _AddRunScreenState();
}

// declare as global for map_screen to retrieve name of run entry from textfield
TextEditingController runNameController = TextEditingController();

class _AddRunScreenState extends State<AddRunScreen> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            labelText: 'Add a name to your Run Entry'
          ),
          controller: runNameController,
        ),
        ElevatedButton(
          child: const Text("ADD"),
          onPressed: () {
            Navigator.pop(context);
          }
        ),
      ],
    );
  }
}
