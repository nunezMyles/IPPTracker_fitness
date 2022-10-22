import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

int navBarselectedIndex = 0;

class _BottomNavBarState extends State<BottomNavBar> {
  void _onItemTapped(int index) {

    setState(() {
      navBarselectedIndex = index;
    });

    switch(index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/map');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/progress');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/settings');
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.blue.shade700,
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
            icon: Icon(Icons.insert_chart_outlined),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: navBarselectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.lightBlueAccent,
        onTap: _onItemTapped,
      );
  }
}