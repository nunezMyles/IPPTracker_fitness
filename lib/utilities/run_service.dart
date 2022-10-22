import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../models/run_exercise.dart';
import '../widgets/showSnackBar.dart';
import 'package:http/http.dart' as http;

String webServerUri = 'https://helpful-seer-366001.as.r.appspot.com/'; // for local, use http://localhost:3000

class ExerciseService {

  Future<bool> removeRun(BuildContext context, String runId) async {
    final response = await http.post(
      Uri.parse('$webServerUri/api/exercise/removeRun'),
      body: jsonEncode({
        'id': runId,
      }),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    if (response.statusCode == 200) {
      return true;
    }
    else {
      showSnackbar(context, 'Fail to delete run.');
      return false;
    }
  }

  Future<List<RunExercise>> fetchRuns(BuildContext context, String email) async {
    final response = await http.post(
      Uri.parse('$webServerUri/api/exercise/getRun'),
      body: jsonEncode({
        'email': email,
      }),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );

    if (response.statusCode == 200) {

      // convert 'response.body' into a known datatype for listviewbuilder by declaring
      // contents of 'response.body' as list + map each content into a
      // RunExercise object inside that list
      List<RunExercise> runExerciseList(String str) => List<RunExercise>.from(
              json.decode(str).map((x) => RunExercise.fromJson(x))
      );

      return runExerciseList(response.body);

    } else {
      throw Exception('Failed to load run data');
    }
  }

}