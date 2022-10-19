import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:my_fitness/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../widgets/showSnackBar.dart';
import 'package:http/http.dart' as http;

String webServerUri = 'https://helpful-seer-366001.as.r.appspot.com/'; // for local use http://localhost:3000

void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch(response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      showSnackbar(context, jsonDecode(response.body)['msg']);
      break;
    case 500:
      showSnackbar(context, jsonDecode(response.body)['error']);
      break;
    default:
      showSnackbar(context, response.body);
  }
}

class AuthService {
  void signUpUser({
    required BuildContext context,
    required String name,
    required String email,
    required String password
  }) async {
    try {
      User user = User(
          id: '',
          name: name,
          password: password,
          email: email,
          address: '',
          type: '',
          token: ''
      );
      http.Response res = await http.post(
        Uri.parse('$webServerUri/api/signup'),
        body: user.toJson(),
        headers: <String, String> {
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackbar(context, 'Account created! Please login again');
        },
      );
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  void signInUser({
    required BuildContext context,
    required String email,
    required String password
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$webServerUri/api/signin'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String> {
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);
          await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
          Navigator.pushReplacementNamed(context, '/home');
        },
      );
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  void getUserData(
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? token = prefs.getString('x-auth-token');
      if (token == null) {
        prefs.setString('x-auth-token', '');
      }
      
      var tokenRes = await http.post(
        Uri.parse('$webServerUri/tokenIsValid'),
        headers: <String, String> {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!
        },
      );

      var response = jsonDecode(tokenRes.body);
      if (response == true) {
       //await
      }
      /*http.Response res = await http.post(
        Uri.parse('$webServerUri/api/signin'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String> {
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );*/

      /*httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);
          await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
          Navigator.pushReplacementNamed(context, '/home');
        },
      );*/
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

}