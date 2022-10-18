import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('hello'),
      ),
      body: Column(
        children: [
          Center(
            child: Text('Flutter Demo'),
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

    