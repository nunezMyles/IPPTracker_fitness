import 'package:flutter/material.dart';
import 'package:my_fitness/models/run_exercise.dart';
import 'package:my_fitness/utilities/account_service.dart';
import 'package:my_fitness/utilities/run_service.dart';
import 'package:my_fitness/widgets/bottomNavBar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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
                                  title: Text(
                                    snapshot.data![index].name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  leading: const Icon(
                                    Icons.run_circle_outlined,
                                    size: 40,
                                    color: Colors.lightBlueAccent
                                  ),
                                  subtitle: Text(DateFormat('MMM dd')
                                      .format(DateFormat('y-MM-ddTHH:mm:ss.SSSZ')
                                      .parse(snapshot.data![index].dateTime.toString()))
                                      + ' at '
                                      + DateFormat('HH:mm a')
                                      .format(DateFormat('y-MM-ddTHH:mm:ss.SSSZ')
                                      .parse(snapshot.data![index].dateTime.toString()))
                                  ),

                                  //subtitle: Text(snapshot.data![index].dateTime.toString()),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(snapshot.data![index].distance + ' km'),
                                      const SizedBox(height: 2),
                                      Text(snapshot.data![index].timing),
                                      const SizedBox(height: 2),
                                      const Text('7:15 /km')
                                    ],
                                  ),

                                  onLongPress: () async {
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

    