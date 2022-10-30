import 'dart:convert';

import 'package:flutter/cupertino.dart';import '../models/global_variables.dart';


import '../models/situp_exercise.dart';
import '../widgets/showSnackBar.dart';
import 'package:http/http.dart' as http;



class SitUpService {

  Future<void> removeSitUp(BuildContext context, String sitUpId) async {
    final response = await http.post(
      Uri.parse('$webServerUri/api/exercise/removeSitUp'),
      body: jsonEncode({
        'id': sitUpId,
      }),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    if (response.statusCode != 200) {
      showSnackBar(context, 'Fail to delete sit-up.');
    }
  }

  Future<void> createSitUp(BuildContext context, SitUpExercise pushUpExercise) async {
    final response = await http.post(
      Uri.parse('$webServerUri/api/exercise/createSitUp'),
      body: pushUpExercise.toJson(),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    if (response.statusCode == 200) {
      showSnackBar(context, 'Sit-up added.');
    }
    else {
      showSnackBar(context, 'Failed to add sit-up entry.');
    }
  }

  Future<List<SitUpExercise>> fetchSitUps(BuildContext context, String email) async {
    final response = await http.post(
      Uri.parse('$webServerUri/api/exercise/getSitUp'),
      body: jsonEncode({
        'email': email,
      }),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );

    if (response.statusCode == 200) {
      List<SitUpExercise> sitUpExerciseList(String str) => List<SitUpExercise>.from(
          json.decode(str).map((x) => SitUpExercise.fromJson(x))
      );
      //print(response.body);
      //print(pushUpExerciseList(response.body));
      return sitUpExerciseList(response.body);

    } else {
      throw Exception('Failed to load sit-up data');
    }
  }


}