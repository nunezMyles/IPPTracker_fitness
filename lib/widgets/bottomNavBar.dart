import 'package:flutter/material.dart';
import 'package:my_fitness/screens/calendar_screen.dart';
import 'package:my_fitness/screens/map_screen.dart';
import 'package:my_fitness/screens/settings_screen.dart';

import '../screens/home_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

int navBarselectedIndex = 0;
int pageTransitionDuration = 50;

class _BottomNavBarState extends State<BottomNavBar> {
  void _onItemTapped(int index) {

    setState(() {
      navBarselectedIndex = index;
    });

    switch(index) {
      case 0:
        Navigator.push(context, PageRouteBuilder(
          pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation
              ) => const HomeScreen(),
          transitionDuration: Duration(milliseconds: pageTransitionDuration),
          transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,) => FadeTransition(opacity: animation, child: child),
        ));
        break;
      case 1:
        Navigator.push(context, PageRouteBuilder(
          pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation
              ) => const MapScreen(),
          transitionDuration: Duration(milliseconds: pageTransitionDuration),
          transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,) => FadeTransition(opacity: animation, child: child),
        ));
        break;
      case 2:
        Navigator.push(context, PageRouteBuilder(
          pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation
              ) => const CalendarScreen(),
          transitionDuration: Duration(milliseconds: pageTransitionDuration),
          transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,) => FadeTransition(opacity: animation, child: child),
        ));
        break;
      case 3:
        Navigator.push(context, PageRouteBuilder(
          pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation
              ) => const SettingsScreen(),
          transitionDuration: Duration(milliseconds: pageTransitionDuration),
          transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,) => FadeTransition(opacity: animation, child: child),
        ));
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color.fromARGB(255, 23, 23, 23),
      type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_run),
            label: 'Activities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: navBarselectedIndex,
        selectedItemColor: const Color.fromARGB(255, 179, 161, 79),
        unselectedItemColor: const Color.fromARGB(255, 120, 120, 120),
        onTap: _onItemTapped,
      );
  }
}
