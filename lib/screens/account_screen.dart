import 'package:flutter/material.dart';

import '../utilities/account_service.dart';
import '../widgets/bottomNavBar.dart';
import '../widgets/showFilterDialog.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                filterValues = [true, true, true, true];
                navBarselectedIndex = 0;
                AccountService().logOut(context);
              });
            },
          )
        ],
      ),
    );
  }
}
