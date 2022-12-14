import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../models/global_variables.dart';
import '../models/run_exercise.dart';
import '../widgets/showSnackBar.dart';
import 'package:http/http.dart' as http;

class RunService {

  Future<void> removeRun(BuildContext context, String runId) async {
    final response = await http.post(
      Uri.parse('$webServerUri/api/exercise/removeRun'),
      body: jsonEncode({
        'id': runId,
      }),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    if (response.statusCode != 200) {
      showSnackBar(context, 'Fail to delete run.');
    }
  }

  Future<void> createRun(BuildContext context, RunExercise runExercise) async {
    final response = await http.post(
      Uri.parse('$webServerUri/api/exercise/createRun'),
      body: runExercise.toJson(),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    if (response.statusCode == 200) {
      showSnackBar(context, 'Run added.');
    }
    else {
      showSnackBar(context, 'Failed to add run.');
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
      // (1) convert 'response.body' into a known datatype for ListViewBuilder by declaring
      // contents of 'response.body' as items of a list + map each content inside that list
      // into a RunExercise object
      // (2) reverse the list to show newest entry at the top when building in futurebuilder
      List<RunExercise> runExerciseList(String str) => List<RunExercise>.from(
              json.decode(str).map((x) => RunExercise.fromJson(x))
      );
      //print(response.body);
      return runExerciseList(response.body);

    } else {
      throw Exception('Failed to load run data');
    }
  }

}