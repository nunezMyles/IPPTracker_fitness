import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:my_fitness/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../widgets/showSnackBar.dart';
import '../utilities/http_error_handle.dart';
import 'package:http/http.dart' as http;

String webServerUri = 'https://helpful-seer-366001.as.r.appspot.com/'; // for local use http://localhost:3000

class AuthService {

  void signUpUser({
    required BuildContext context,
    required String name,
    required String email,
    required String password
  }) async {
    try {

      // create user object w/ inputs from sign up screen text controllers
      User user = User(
          id: '',
          name: name,
          password: password,
          email: email,
          address: '',
          type: '',
          token: ''
      );

      // send json converted user object to api uri along w/ headers
      // after that obtain api response + store into variable res
      http.Response res = await http.post(
        Uri.parse('$webServerUri/api/signup'),
        body: user.toJson(),
        headers: <String, String> {
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      // handle successful/unsuccessful logins w/ SnackBar widget call
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Account created! Please login again');
        },
      );

    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void signInUser({
    required BuildContext context,
    required String email,
    required String password
  }) async {
    try {
      // send json converted email, password to api uri along w/ headers
      // after that obtain api response + store into variable res
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

      // handle successful/unsuccessful logins w/ SnackBar widget call
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
      showSnackBar(context, e.toString());
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
        http.Response userRes = await http.get(
          Uri.parse('$webServerUri/'),
          headers: <String, String> {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );

        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
      }

    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

}