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
  void initState() {
    super.initState();

    // Start listening to changes.
    pushUpDurationController.addListener(_printLatestValue);
  }

  void _printLatestValue() {
    if (pushUpDurationController.text.isEmpty) {
      _validate = true;
    } else {
      _validate = false;
    }
    // setstate to update error text display
    setState(() {

    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    pushUpDurationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
              labelText: 'Name of push-up Entry'
          ),
          controller: pushUpNameController,
        ),
        TextField(
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            labelText: 'Number of push-ups',
            //errorText: _validate ? 'Value Can\'t Be Empty' : null,
          ),

          controller: pushUpRepsController,
        ),
        TextField(
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            labelText: 'Time taken (s)',
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

              Navigator.push(context, PageRouteBuilder(
                pageBuilder: (
                    BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation
                    ) => const HomeScreen(),
                transitionDuration: const Duration(milliseconds: 50),
                transitionsBuilder: (
                    BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child,) => FadeTransition(opacity: animation, child: child),
              ));
            }
        ),
      ],
    );
  }
}
