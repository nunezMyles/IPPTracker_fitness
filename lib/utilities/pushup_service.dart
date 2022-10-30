import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../models/global_variables.dart';
import '../models/pushup_exercise.dart';
import '../widgets/showSnackBar.dart';
import 'package:http/http.dart' as http;

class PushUpService {

  Future<void> removePushUp(BuildContext context, String pushUpId) async {
    final response = await http.post(
      Uri.parse('$webServerUri/api/exercise/removePushUp'),
      body: jsonEncode({
        'id': pushUpId,
      }),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    if (response.statusCode != 200) {
      showSnackBar(context, 'Fail to delete push-up.');
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
      showSnackBar(context, 'Push-up added.');
    }
    else {
      showSnackBar(context, 'Failed to add push-up entry.');
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
      );
      //print(response.body);
      //print(pushUpExerciseList(response.body));
      return pushUpExerciseList(response.body);

    } else {
      throw Exception('Failed to load push-up data');
    }
  }


}