import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

int _selectedIndex = 0;

class _BottomNavBarState extends State<BottomNavBar> {

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch(index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      default:
        break;
    }


  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.blue.shade600,
      type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.lightBlueAccent,
        onTap: _onItemTapped,
      );
  }
}
