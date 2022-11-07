import 'package:flutter/material.dart';

import '../utilities/account_service.dart';
import '../widgets/bottomNavBar.dart';
import '../widgets/activityFilterDialog.dart';
import 'map_screen.dart';
import '../screens/home_screen.dart';

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
                isLocationOn = false; // reset app loc display
                filterValues = [true, true, true, true]; // reset activity filter
                navBarselectedIndex = 0; // reset nav bar selection
                AccountService().logOut(context);
              });
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 55.0,
            //backgroundImage: AssetImage('../fitness_app_icon3.png'),
            backgroundColor: Colors.blue,
          ),
          Text(user.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32.0,
              color: Colors.white,
              fontFamily: 'Raleway',
            ),
          ),
          /*const Text(
            '180 Ang Mo Kio Ave 8 Singapore 569830',
            style: TextStyle(
              color: Color(0xfff7f7f7),
            ),
          ),*/
          const SizedBox(height: 20.0),
          Card(
            elevation: 0,
            color: const Color(0xff0a1651).withOpacity(0.2),
            child: const ListTile(
              leading: Icon(Icons.phone, color: Color(0xffffe7aa)),
              title: Text(
                '9726 6596',
              ),
            ),
          ),
          Card(
            elevation: 0,
            color: const Color(0xff0a1651).withOpacity(0.2),
            child: ListTile(
              leading: const Icon(Icons.mail, color: Color(0xff1edfa4)),
              title: Text(
                user.email,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
