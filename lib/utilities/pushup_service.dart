import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../models/pushup_exercise.dart';
import '../widgets/showSnackBar.dart';
import 'package:http/http.dart' as http;

String webServerUri = 'https://helpful-seer-366001.as.r.appspot.com/'; // for local, use http://localhost:3000

class PushUpService {

  Future<void> removePushUp(BuildContext context, String runId) async {
    final response = await http.post(
      Uri.parse('$webServerUri/api/exercise/removePushUp'),
      body: jsonEncode({
        'id': runId,
      }),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    if (response.statusCode != 200) {
      showSnackbar(context, 'Fail to delete push-up.');
    }
  }

  Future<void> createPushUp(BuildContext context, PushUpExercise pushUpExercise) async {
    final response = await http.post(
      Uri.parse('$webServerUri/api/exercise/createPushUp'),
      body: pushUpExercise.toJson(),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    if (response.statusCode == 200) {
      showSnackbar(context, 'Push-up added.');
    }
    else {
      showSnackbar(context, 'Failed to add push-up entry.');
    }
  }

  Future<List<PushUpExercise>> fetchPushUps(BuildContext context, String email) async {
    final response = await http.post(
      Uri.parse('$webServerUri/api/exercise/getPushUp'),
      body: jsonEncode({
        'email': email,
      }),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );

    if (response.statusCode == 200) {
      List<PushUpExercise> pushUpExerciseList(String str) => List<PushUpExercise>.from(
          json.decode(str).map((x) => PushUpExercise.fromJson(x))
      ).reversed.toList();
      //print(response.body);
      //print(pushUpExerciseList(response.body));
      return pushUpExerciseList(response.body);

    } else {
      throw Exception('Failed to load push-up data');
    }
  }


}