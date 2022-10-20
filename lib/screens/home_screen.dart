import 'package:flutter/material.dart';
import 'package:my_fitness/utilities/account_services.dart';
import 'package:my_fitness/widgets/bottom_navBar.dart';
import 'package:my_fitness/utilities/database_service.dart';

import '../models/user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<UserProvider>(context).user;
    // print(user)

    return Scaffold(
      bottomNavigationBar: const BottomNavBar(),
      appBar: AppBar(
        title: const Text('hello'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                AccountService().logOut(context);
              });
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {

        },
      ),
      /*body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: StreamBuilder<User>(
                  stream: DBConnection().getCollection(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.,
                          itemBuilder: itemBuilder
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                )
            )
          ],
        ),
      ),*/
    );
  }
}

    