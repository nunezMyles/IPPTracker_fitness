import 'package:flutter/material.dart';
import '../widgets/bottomNavBar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';


class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}


class _CalendarScreenState extends State<CalendarScreen> {
  final CalendarController _calendarController = CalendarController();
  var meetings = <Meeting>[];

  List<Meeting> _getDataSource() {
    return meetings;
  }

  @override
  initState(){
    _calendarController.selectedDate = DateTime(2022, 10, 29);
    _calendarController.displayDate = DateTime(2022, 10, 29);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const BottomNavBar(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Workout Calendar',
          style: TextStyle(
              color: Colors.white
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, color: Colors.greenAccent, size: 30),
        backgroundColor: const Color.fromARGB(255, 23, 23, 23).withOpacity(0.9),
        onPressed: () {
          setState(() {
            final DateTime startTime = _calendarController.selectedDate!;
            final DateTime endTime = _calendarController.selectedDate!.add(const Duration(hours: 2));

            meetings.add(Meeting(
                'Conference',
                startTime,
                endTime,
                const Color(0xFF0F8644),
                false
            ));
          });
        }
      ),
      body: Theme(
        data: ThemeData(colorScheme: const ColorScheme.dark()),
        child: SfCalendar(
          view: CalendarView.month,
          firstDayOfWeek: 1,
          controller: _calendarController,
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
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(this.source);

  List<Meeting> source;

  @override
  List<dynamic> get appointments => source;

  @override
  DateTime getStartTime(int index) {
    return source[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return source[index].to;
  }

  @override
  String getSubject(int index) {
    return source[index].eventName;
  }

  @override
  Color getColor(int index) {
    return source[index].background;
  }

  @override
  bool isAllDay(int index) {
    return source[index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}

