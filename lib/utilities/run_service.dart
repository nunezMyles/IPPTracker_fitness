import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../models/run_exercise.dart';
import '../utilities/http_error_handle.dart';
import '../widgets/showSnackBar.dart';
import 'package:http/http.dart' as http;

String webServerUri = 'https://helpful-seer-366001.as.r.appspot.com/'; // for local, use http://localhost:3000

class ExerciseService {

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
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          showSnackbar(context, 'Run exercise data retrieved!');
        },
      );

      print(response.body);

      List<RunExercise> runExerciseList(String str) =>
          List<RunExercise>.from(
              json.decode(str).map((x) => RunExercise.fromJson(x)));

      print(runExerciseList(response.body));

      return runExerciseList(response.body);

    } else {
      throw Exception('Failed to load run data');
    }
  }

}