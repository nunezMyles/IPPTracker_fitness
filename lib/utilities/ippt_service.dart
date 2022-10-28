import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:my_fitness/models/ippt_training.dart';

import '../screens/home_screen.dart';
import '../widgets/showSnackBar.dart';
import 'package:http/http.dart' as http;

String webServerUri = 'https://helpful-seer-366001.as.r.appspot.com/'; // for local, use http://localhost:3000

class IpptService {

  Future<void> createIpptTraining(BuildContext context, String name, String age, String runTiming, String pushupReps, String situpReps) async {
    String apiBaseURL = 'https://ippt.vercel.app/api?';
    String score;

    final response1 = await http.get(Uri.parse(
        apiBaseURL
            + 'age=' + age
            + '&situps=' + situpReps
            + '&pushups=' + pushupReps
            + "&run=" + runTiming
    ));

    if (response1.statusCode != 200) {
      showSnackBar(context, 'Failed to calculate score.');
      return;
    }
    score = jsonDecode(response1.body)['total'].toString();

    IpptTraining ipptTraining = IpptTraining(
        id: '',
        name: name,
        email: user.email,
        age: age,
        runTiming: runTiming,
        pushupReps: pushupReps,
        situpReps: situpReps,
        score: score,
        dateTime: '',
        type: ''
    );

    final response2 = await http.post(
      Uri.parse('$webServerUri/api/exercise/createIpptTraining'),
      body: ipptTraining.toJson(),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    if (response2.statusCode == 200) {
      showSnackBar(context, 'IPPT training added.');
    }
    else {
      showSnackBar(context, 'Failed to add IPPT entry.');
    }
  }

  Future<List<IpptTraining>> fetchIpptTraining(BuildContext context, String email) async {
    final response = await http.post(
      Uri.parse('$webServerUri/api/exercise/getIpptTraining'),
      body: jsonEncode({
        'email': email,
      }),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );

    if (response.statusCode == 200) {
      List<IpptTraining> ipptTrainingList(String str) => List<IpptTraining>.from(
          json.decode(str).map((x) => IpptTraining.fromJson(x))
      );
      print(response.body);
      return ipptTrainingList(response.body);

    } else {
      throw Exception('Failed to load ippt data');
    }
  }
}