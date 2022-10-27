import 'package:flutter/material.dart';
import 'package:my_fitness/models/pushup_exercise.dart';

import '../utilities/pushup_service.dart';
import 'package:flutter/services.dart';
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
  bool _repsValidate = true;
  bool _durationValidate = true;

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    pushUpRepsController.addListener(_printLatestValue);
    pushUpDurationController.addListener(_printLatestValue);
  }

  void _printLatestValue() {
    if (pushUpRepsController.text.isEmpty) {
      _repsValidate = true;
    } else {
      _repsValidate = false;
    }
    if (pushUpDurationController.text.isEmpty) {
      _durationValidate = true;
    } else {
      _durationValidate = false;
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        children: [
          const SizedBox(height: 2),
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
              errorText: _repsValidate ? 'Value can\'t be empty.' : null,
            ),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
            controller: pushUpRepsController,
          ),
          TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              labelText: 'Time taken (s)',
              errorText: _durationValidate ? 'Value can\'t be empty.' : null,
            ),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
            controller: pushUpDurationController,
          ),
          const SizedBox(height: 1),
          ElevatedButton(
              child: const Text("ADD"),
              onPressed: () async {

                // if no inputs for reps & duration, do nothing
                if (_repsValidate || _durationValidate) {
                  return;
                }

                if (pushUpNameController.text.isEmpty) {
                  pushUpNameController.text = 'Unnamed entry';
                }

                // create a pushup object
                PushUpExercise pushUpEntry = PushUpExercise(
                    id: '',
                    name: pushUpNameController.text,
                    email: user.email,
                    timing: pushUpDurationController.text,
                    reps: pushUpRepsController.text,
                    dateTime: '',
                    type: ''
                );

                // send pushup object to DB through an api call
                await PushUpService().createPushUp(context, pushUpEntry);

                // navigate back to home screen
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
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
