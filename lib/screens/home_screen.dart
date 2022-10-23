import 'package:flutter/material.dart';
import 'package:my_fitness/models/run_exercise.dart';
import 'package:my_fitness/utilities/account_service.dart';
import 'package:my_fitness/utilities/run_service.dart';
import 'package:my_fitness/widgets/bottomNavBar.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

dynamic user;

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      bottomNavigationBar: const BottomNavBar(),
      appBar: AppBar(
        title: const Text('Activities'),
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
          navBarselectedIndex = 1;
          Navigator.pushReplacementNamed(context, '/map');
        },
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: FutureBuilder(
                  future: RunService().fetchRuns(context, user.email),
                  builder: (context, AsyncSnapshot<List<RunExercise>> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(1.5),
                              child: Card(
                                elevation: 3,
                                child: ListTile(
                                  title: Text(snapshot.data![index].id),
                                  subtitle: Text(snapshot.data![index].dateTime.toString()),
                                  trailing: Text(snapshot.data![index].timing),

                                  onLongPress: () async {
                                    //print(snapshot.data![index].id + '===========================================================================================================');
                                    bool delConfirm = await RunService().removeRun(context, snapshot.data![index].id);
                                    if (delConfirm) {
                                     setState(() {});
                                    }
                                  },
                                ),
                              ),
                            );
                          }
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
            )
          ],
        ),
      ),
    );
  }
}

    