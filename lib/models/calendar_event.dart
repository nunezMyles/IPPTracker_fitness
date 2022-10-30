import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(this.source);

  List<Event> source;

  @override
  List<dynamic> get appointments => source;

  @override
  DateTime getStartTime(int index) {
    return DateTime.parse(source[index].from);
  }

  @override
  DateTime getEndTime(int index) {
    return DateTime.parse(source[index].to);
  }

  @override
  String getSubject(int index) {
    return source[index].eventName;
  }

  @override
  Color getColor(int index) {
    switch(source[index].background) {
      case 'blue':
        return Colors.blue;
      case 'orange':
        return Colors.deepOrangeAccent;
      case 'red':
        return Colors.blueGrey;
      case 'green':
        return Colors.green;
      case 'purple':
        return Colors.purple;
      default:
        return Colors.black;
    }
  }

  @override
  bool isAllDay(int index) {
    return source[index].isAllDay;
  }
}

class Event {
  String id;
  String eventName;
  String email;
  String from;
  String to;
  String background;
  bool isAllDay;
  String type;

  Event({
    required this.id,
    required this.eventName,
    required this.email,
    required this.from,
    required this.to,
    required this.background,
    required this.isAllDay,
    required this.type,
  });

  String toJson() => json.encode(toMap());

  // (2)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'eventName': eventName,
      'email': email,
      'from': from,
      'to': to,
      'background': background,
      'isAllDay': isAllDay,
      'type': type
    };
  }

  // json > dart object
  factory Event.fromJson(Map<String, dynamic> map) {
    return Event(
        id: map['_id'] ?? '',
        eventName: map['eventName'] ?? '',
        email: map['email'] ?? '',
        from: map['from'] ?? '',
        to: map['to'] ?? '',
        background: map['background'] ?? '',
        isAllDay: map['isAllDay'] ?? '',
        type: map['type'] ?? ''
    );
  }
}
