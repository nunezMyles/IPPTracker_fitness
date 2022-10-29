import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({Key? key}) : super(key: key);

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  bool _startTimeValidate = true;
  bool _endTimeValidate = true;

  TextEditingController eventNameController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    startTimeController.addListener(_printLatestValue);
    endTimeController.addListener(_printLatestValue);
  }

  void _printLatestValue() {
    if (startTimeController.text.isEmpty) {
      _startTimeValidate = true;
    } else {
      _startTimeValidate = false;
    }
    if (endTimeController.text.isEmpty) {
      _endTimeValidate = true;
    } else {
      _endTimeValidate = false;
    }
    // setstate to update error text display
    setState(() {

    });
  }

  @override
  void dispose() {
    // Clean up controllers
    startTimeController.dispose();
    endTimeController.dispose();
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
                labelText: 'Name of push-up entry'
            ),
            controller: eventNameController,
          ),
          TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              labelText: 'No. of push-ups (reps)',
              errorText: _startTimeValidate ? 'Value can\'t be empty.' : null,
            ),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
            controller: startTimeController,
          ),
          TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              labelText: 'Time taken (s)',
              errorText: _endTimeValidate ? 'Value can\'t be empty.' : null,
            ),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
            controller: endTimeController,
          ),
          const SizedBox(height: 1),
          ElevatedButton(
              child: const Text("ADD"),
              onPressed: () async {

                // if no inputs for reps & duration, do nothing
                if (_startTimeValidate || _endTimeValidate) {
                  return;
                }

                if (eventNameController.text.isEmpty) {
                  eventNameController.text = 'Unnamed event';
                }

                // create a pushup object
                /*PushUpExercise pushUpEntry = PushUpExercise(
                    id: '',
                    name: eventNameController.text,
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
                ));*/
              }
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
