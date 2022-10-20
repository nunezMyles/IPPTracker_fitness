import 'package:flutter/material.dart';
import 'package:my_fitness/providers/user_provider.dart';
import 'package:my_fitness/widgets/bottom_navBar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(),
      appBar: AppBar(
        title: const Text('hello'),
      ),
      body: Column(
        children: [
          Center(
            child: Text(user.toJson()),
          ),
          ElevatedButton(
            onPressed: () {

            },
            child: const Text('click'),
          )
        ],
      ),
    );
  }
}

    