import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../models/pushup_exercise.dart';
import '../widgets/showSnackBar.dart';
import 'package:http/http.dart' as http;

String webServerUri = 'https://helpful-seer-366001.as.r.appspot.com/'; // for local, use http://localhost:3000

class PushUpService {

  Future<void> createPushUp(BuildContext context, PushUpExercise pushUpExercise) async {
    final response = await http.post(
      Uri.parse('$webServerUri/api/exercise/createPushUp'),
      body: pushUpExercise.toJson(),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    if (response.statusCode == 200) {
      showSnackbar(context, 'Push-up entry added.');
    }
    else {
      showSnackbar(context, 'Failed to add push-up entry.');
    }
  }

}