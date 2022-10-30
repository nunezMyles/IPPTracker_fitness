import 'package:flutter/material.dart';
import 'package:my_fitness/screens/add_event_screen.dart';
import 'package:my_fitness/utilities/calendar_event_service.dart';
import '../widgets/bottomNavBar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../models/calendar_event.dart';
import 'home_screen.dart';


class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}


CalendarController calendarController = CalendarController();
var meetings = <Event>[];

class _CalendarScreenState extends State<CalendarScreen> {

  List<Event> _getDataSource() {
    return meetings;
  }

  @override
  initState(){
    calendarController.selectedDate = DateTime(2022, 10, 29);
    calendarController.displayDate = DateTime(2022, 10, 29);
    EventService().fetchEvents(context, user.email).then((snapshot) {
      setState(() {
        for (Event event in snapshot) {
          meetings.add(event);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 80, 80, 80),
      bottomNavigationBar: const BottomNavBar(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Activity Planner',
          style: TextStyle(
              color: Colors.white
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, color: Colors.greenAccent, size: 30),
        backgroundColor: const Color.fromARGB(255, 23, 23, 23).withOpacity(0.9),
        onPressed: () async {
          await showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            backgroundColor: Colors.white54.withOpacity(0.9),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)
              ),
            ),
            builder: (BuildContext context) {
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: const AddEventScreen(),
                ),
              );
            },
          );
        }
      ),
      body: Theme(
        data: ThemeData(colorScheme: const ColorScheme.dark()),
        child: SafeArea(
          child: SfCalendar(
            view: CalendarView.month,
            firstDayOfWeek: 1,
            controller: calendarController,
            dataSource: MeetingDataSource(_getDataSource()),
            //allowDragAndDrop: true,
            showDatePickerButton: true,
            backgroundColor: const Color.fromARGB(255, 46, 46, 46),
            todayHighlightColor: const Color.fromARGB(255, 211, 186, 109),
            selectionDecoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: const Color.fromARGB(255, 211, 186, 109), width: 2),
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              shape: BoxShape.rectangle,
            ),
            monthViewSettings: const MonthViewSettings(
              showAgenda: true,
              showTrailingAndLeadingDates: false,
            ),
          ),
        ),
      ),
    );
  }
}


