import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:my_fitness/models/calendar_event.dart';

import '../screens/home_screen.dart';
import '../widgets/showSnackBar.dart';
import 'package:http/http.dart' as http;

String webServerUri = 'https://helpful-seer-366001.as.r.appspot.com/'; // for local, use http://localhost:3000

class EventService {

  Future<void> removeEvent(BuildContext context, String eventId) async {
    final response = await http.post(
      Uri.parse('$webServerUri/api/removeEvent'),
      body: jsonEncode({
        'id': eventId,
      }),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    if (response.statusCode != 200) {
      showSnackBar(context, 'Fail to delete event.');
    }
  }

  Future<void> createEvent(BuildContext context, Event event) async {
    final response = await http.post(
      Uri.parse('$webServerUri/api/createEvent'),
      body: event.toJson(),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    if (response.statusCode == 200) {
      //showSnackBar(context, 'Event added.');
    }
    else {
      //showSnackBar(context, 'Failed to add event.');
    }
  }

  Future<List<Event>> fetchEvents(BuildContext context, String email) async {
    final response = await http.post(
      Uri.parse('$webServerUri/api/getEvent'),
      body: jsonEncode({
        'email': email,
      }),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );

    if (response.statusCode == 200) {
      List<Event> eventList(String str) => List<Event>.from(
          json.decode(str).map((x) => Event.fromJson(x))
      );
      //print(response.body);
      //print(pushUpExerciseList(response.body));
      return eventList(response.body);

    } else {
      throw Exception('Failed to load event data');
    }
  }


}