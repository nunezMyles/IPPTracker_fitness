import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utilities/ippt_service.dart';
import 'home_screen.dart';

class AddIPPTScreen extends StatefulWidget {
  const AddIPPTScreen({Key? key}) : super(key: key);

  @override
  State<AddIPPTScreen> createState() => _AddIPPTScreenState();
}

class _AddIPPTScreenState extends State<AddIPPTScreen> {
  TextEditingController ipptNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController runTimeController = TextEditingController();
  TextEditingController pushUpRepsController = TextEditingController();
  TextEditingController sitUpRepsController = TextEditingController();
  bool _ageValidate = true;
  bool _runTimeValidate = true;
  bool _pushUpRepsValidate = true;
  bool _sitUpRepsValidate = true;

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    ageController.addListener(_printLatestValue);
    runTimeController.addListener(_printLatestValue);
    pushUpRepsController.addListener(_printLatestValue);
    sitUpRepsController.addListener(_printLatestValue);
  }

  void _printLatestValue() {
    ageController.text.isEmpty ? _ageValidate = true : _ageValidate = false;
    runTimeController.text.isEmpty ? _runTimeValidate = true : _runTimeValidate = false;
    pushUpRepsController.text.isEmpty ? _pushUpRepsValidate = true : _pushUpRepsValidate = false;
    sitUpRepsController.text.isEmpty ? _sitUpRepsValidate = true : _sitUpRepsValidate = false;

    setState(() {

    });
  }

  @override
  void dispose() {
    // Clean up controllers
    ipptNameController.dispose();
    ageController.dispose();
    runTimeController.dispose();
    pushUpRepsController.dispose();
    sitUpRepsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        children: [
          TextField(
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
                labelText: 'Name of IPPT training'
            ),
            controller: ipptNameController,
          ),
          TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              labelText: 'Age',
              errorText: _ageValidate ? 'Value can\'t be empty.' : null,
            ),
            controller: ageController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
          ),
          TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
                labelText: 'Time taken for 2.4km (s)',
              errorText: _runTimeValidate ? 'Value can\'t be empty.' : null,
            ),
            controller: runTimeController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
          ),
          TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
                labelText: 'No. of push-ups (reps)',
              errorText: _pushUpRepsValidate ? 'Value can\'t be empty.' : null,
            ),
            controller: pushUpRepsController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
          ),
          TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
                labelText: 'No. of sit-ups (reps)',
              errorText: _sitUpRepsValidate ? 'Value can\'t be empty.' : null,
            ),
            controller: sitUpRepsController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 1),
          ElevatedButton(
              child: const Text("ADD"),
              onPressed: () async {

                if (_ageValidate || _runTimeValidate || _pushUpRepsValidate || _sitUpRepsValidate) {
                  return;
                }

                if (ipptNameController.text.isEmpty) {
                  ipptNameController.text = 'Unnamed entry';
                }

                await IpptService().createIpptTraining(
                    context,
                    ipptNameController.text,
                    ageController.text,
                    runTimeController.text,
                    pushUpRepsController.text,
                    sitUpRepsController.text
                );

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
