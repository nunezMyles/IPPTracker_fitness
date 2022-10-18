import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../models/user.dart';
import '../widgets/showSnackBar.dart';
import 'package:http/http.dart' as http;

String webServer_uri = 'http://localhost:3000';

void httpErrorHandle({
  required http.Response response,
  required  BuildContext context,
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
          Uri.parse('$webServer_uri/api/signup'),
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
}