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
                labelText: 'Name of IPPT Entry'
            ),
            controller: ipptNameController,
          ),
          TextField(
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
                labelText: 'Age'
            ),
            controller: ageController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
          ),
          TextField(
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
                labelText: 'Time taken for 2.4km (s)'
            ),
            controller: runTimeController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
          ),
          TextField(
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
                labelText: 'No. of push-ups (reps)'
            ),
            controller: pushUpRepsController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
          ),
          TextField(
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
                labelText: 'No. of sit-ups (reps)'
            ),
            controller: sitUpRepsController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 1),
          ElevatedButton(
              child: const Text("ADD"),
              onPressed: () async {

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
