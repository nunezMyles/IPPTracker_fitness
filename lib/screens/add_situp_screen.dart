import 'package:flutter/material.dart';
import 'package:my_fitness/models/situp_exercise.dart';

import '../utilities/situp_service.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';

class AddSitUpScreen extends StatefulWidget {
  const AddSitUpScreen({Key? key}) : super(key: key);

  @override
  State<AddSitUpScreen> createState() => _AddSitUpScreenState();
}

class _AddSitUpScreenState extends State<AddSitUpScreen> {
  bool _repsValidate = true;
  bool _durationValidate = true;

  TextEditingController sitUpNameController = TextEditingController();
  TextEditingController sitUpDurationController = TextEditingController();
  TextEditingController sitUpRepsController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    sitUpRepsController.addListener(_printLatestValue);
    sitUpDurationController.addListener(_printLatestValue);
  }

  void _printLatestValue() {
    if (sitUpRepsController.text.isEmpty) {
      _repsValidate = true;
    } else {
      _repsValidate = false;
    }
    if (sitUpDurationController.text.isEmpty) {
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
    // Clean up controllers
    sitUpRepsController.dispose();
    sitUpDurationController.dispose();
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
                labelText: 'Name of sit-up entry'
            ),
            controller: sitUpNameController,
          ),
          TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              labelText: 'No. of sit-ups (reps)',
              errorText: _repsValidate ? 'Value can\'t be empty.' : null,
            ),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
            controller: sitUpRepsController,
          ),
          TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              labelText: 'Time taken (s)',
              errorText: _durationValidate ? 'Value can\'t be empty.' : null,
            ),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
            controller: sitUpDurationController,
          ),
          const SizedBox(height: 1),
          ElevatedButton(
              child: const Text("ADD"),
              onPressed: () async {

                // if no inputs for reps & duration, do nothing
                if (_repsValidate || _durationValidate) {
                  return;
                }

                if (sitUpNameController.text.isEmpty) {
                  sitUpNameController.text = 'Unnamed entry';
                }

                // create a pushup object
                SitUpExercise sitUpEntry = SitUpExercise(
                    id: '',
                    name: sitUpNameController.text,
                    email: user.email,
                    timing: sitUpDurationController.text,
                    reps: sitUpRepsController.text,
                    dateTime: '',
                    type: ''
                );

                // send pushup object to DB through an api call
                await SitUpService().createSitUp(context, sitUpEntry);

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
