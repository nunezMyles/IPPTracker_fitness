import 'package:flutter/material.dart';

import '../utilities/account_service.dart';
import '../widgets/bottomNavBar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(),
      appBar: AppBar(
        leadingWidth: 10,
        title: const Text(
          'Settings',
          style: TextStyle(
              color: Colors.white,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.redAccent,
            ),

            onPressed: () {
              setState(() {
                AccountService().logOut(context);
              });
            },
          )
        ],
      ),
    );
  }
}
