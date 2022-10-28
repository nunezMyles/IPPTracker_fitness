import 'package:flutter/material.dart';
import 'package:my_fitness/widgets/showSnackBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountService {

  void logOut(BuildContext context) async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString('x-auth-token', '');
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

}