import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:my_fitness/screens/calendar_screen.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../models/calendar_event.dart';
import '../utilities/calendar_event_service.dart';
import 'home_screen.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({Key? key}) : super(key: key);

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  bool _startTimeValidate = true;
  bool _endTimeValidate = true;

  final Map<String, String> timingMap = {
    "startTime": '',
    "endTime": '',
  };

  TextEditingController eventNameController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();

  Future displayTimePicker(BuildContext context, String type) async {
    var time = await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (time != null) {
      setState(() {
        type == 'start'
            ? startTimeController.text = daytimeToDatetime(time, type)
            : endTimeController.text = daytimeToDatetime(time, type);
      });
    }
  }

  daytimeToDatetime(TimeOfDay t, String type) {
    //final now = DateTime.now();
    DateTime selectedDate = DateTime(
      calendarController.selectedDate!.year,
      calendarController.selectedDate!.month,
      calendarController.selectedDate!.day,
      t.hour,
      t.minute,
    );
    type == 'start'
        ? timingMap.update('startTime', (value) => selectedDate.toString())
        : timingMap.update('endTime', (value) => selectedDate.toString());
    return DateFormat('HH:mm a').format(selectedDate);
  }

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
                labelText: 'Name of event'
            ),
            controller: eventNameController,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: 'From:',
                    errorText: _startTimeValidate ? 'Value can\'t be empty.' : null,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                  controller: startTimeController,
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                child: const Icon(Icons.access_time_rounded),
                onPressed: () => displayTimePicker(context, 'start'),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: 'To:',
                    errorText: _endTimeValidate ? 'Value can\'t be empty.' : null,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                  controller: endTimeController,
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                child: const Icon(Icons.access_time_rounded),
                onPressed: () => displayTimePicker(context, 'end'),
              ),
            ],
          ),
          const SizedBox(height: 3),
          ElevatedButton(
              child: const Text("ADD"),
              onPressed: () async {
                if (_startTimeValidate || _endTimeValidate) {
                  return;
                }
                if (eventNameController.text.isEmpty) {
                  eventNameController.text = 'Unnamed event';
                }

                Event event = Event(
                  id: '',
                  eventName: eventNameController.text,
                  email: user.email,
                  from: timingMap['startTime']!,
                  to: timingMap['endTime']!,
                  background: 'blue',
                  isAllDay: false,
                  type: '',
                );

                await EventService().createEvent(context, event);

                timingMap.clear();

                MeetingDataSource(meetings).notifyListeners(CalendarDataSourceAction.add, [event]);
              }
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}


