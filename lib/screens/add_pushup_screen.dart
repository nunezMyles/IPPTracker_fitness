import 'package:flutter/material.dart';
import 'package:my_fitness/models/pushup_exercise.dart';

import '../utilities/pushup_service.dart';
import 'home_screen.dart';

class AddPushUpScreen extends StatefulWidget {
  const AddPushUpScreen({Key? key}) : super(key: key);

  @override
  State<AddPushUpScreen> createState() => _AddPushUpScreenState();
}

class _AddPushUpScreenState extends State<AddPushUpScreen> {
  TextEditingController pushUpNameController = TextEditingController();
  TextEditingController pushUpDurationController = TextEditingController();
  TextEditingController pushUpRepsController = TextEditingController();
  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
              labelText: 'Name of Push-up Entry'
          ),
          controller: pushUpNameController,
        ),
        TextField(
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            labelText: 'Number of push-ups',
            errorText: _validate ? 'Value Can\'t Be Empty' : null,
          ),

          controller: pushUpRepsController,
        ),
        TextField(
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            labelText: 'Time taken for all push-ups (s)',
            errorText: _validate ? 'Value Can\'t Be Empty' : null,
          ),
          controller: pushUpDurationController,
        ),
        ElevatedButton(
            child: const Text("ADD"),
            onPressed: () async {

              if (pushUpNameController.text.isEmpty) {
                pushUpNameController.text = 'Unnamed entry';
              }

              pushUpDurationController.text.isEmpty ? _validate = true : _validate = false;
              pushUpRepsController.text.isEmpty ? _validate = true : _validate = false;

              PushUpExercise pushUpEntry = PushUpExercise(
                  id: '',
                  name: pushUpNameController.text,
                  email: user.email,
                  timing: pushUpDurationController.text,
                  reps: pushUpRepsController.text,
                  dateTime: '',
                  type: ''
              );

              await PushUpService().createPushUp(context, pushUpEntry);

              Navigator.pop(context);
            }
        ),
      ],
    );
  }
}