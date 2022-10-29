import 'package:flutter/material.dart';
import '../my_flutter_app_icons.dart';

void showAlertDialog(BuildContext context, Function() refresh) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Filter', style: TextStyle(color: Colors.white)),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(23.0))),
        insetPadding: const EdgeInsets.symmetric(horizontal: 100),
        backgroundColor: const Color.fromARGB(255, 46, 46, 46),
        content: AlertCheckbox(notifyParent: refresh),
      );
    },
  );
}

class AlertCheckbox extends StatefulWidget {
  const AlertCheckbox({Key? key, required this.notifyParent}) : super(key: key);
  final Function() notifyParent;

  @override
  State<AlertCheckbox> createState() => _AlertCheckboxState();
}

List<bool> filterValues = [true, true, true, true];

class _AlertCheckboxState extends State<AlertCheckbox> {

  List<Widget> iconWidgets = [
    const Icon(
        Icons.directions_run,
        size: 36,
        color: Colors.orangeAccent
    ),
    const Icon(
        MyFlutterApp.push_ups1,
        size: 35,
        color: Colors.lightBlueAccent
    ),
    const Icon(
        MyFlutterApp.sit_ups,
        size: 34,
        color: Colors.yellowAccent
    ),
    Icon(
      Icons.fact_check_outlined,
      size: 34,
      color: Colors.lightGreenAccent.shade700,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: 220.0,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 4,
          itemBuilder: (BuildContext context, int index) {
            return Theme(
              data: ThemeData(unselectedWidgetColor: Colors.white),
              child: CheckboxListTile(
                activeColor: Colors.transparent,
                checkboxShape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                title: iconWidgets[index],
                value: filterValues[index],
                onChanged: (bool? value) {
                  setState(() {
                    filterValues[index] = value!;
                    widget.notifyParent();
                  });
                },
              ),
            );
          },
        ),
      ),
    );
  }
}


