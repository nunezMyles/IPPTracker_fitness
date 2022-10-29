import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:auto_animated/auto_animated.dart';

import 'package:my_fitness/models/ippt_training.dart';
import 'package:my_fitness/models/pushup_exercise.dart';
import 'package:my_fitness/models/run_exercise.dart';
import 'package:my_fitness/models/situp_exercise.dart';

import '../screens/map_screen.dart';
import 'package:my_fitness/screens/add_situp_screen.dart';
import 'package:my_fitness/screens/add_pushup_screen.dart';
import 'package:my_fitness/screens/add_ippt_activity_screen.dart';

import 'package:my_fitness/utilities/ippt_service.dart';
import 'package:my_fitness/utilities/pushup_service.dart';
import 'package:my_fitness/utilities/run_service.dart';
import 'package:my_fitness/utilities/situp_service.dart';

import '../widgets/bottomNavBar.dart';
import '../widgets/expandingActionBtn.dart';

import '../my_flutter_app_icons.dart';
import '../providers/user_provider.dart';
import '../widgets/showFilterDialog.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

dynamic user;

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> exercisesObjectsList = [];

  String _printDuration(String strDuration) {
    Duration duration = Duration(seconds: int.parse(strDuration));
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  final options = const LiveOptions(
    // Start animation after (default zero)
    delay: Duration(seconds: 0),

    // Show each item through (default 250)
    showItemInterval: Duration(milliseconds: 150),

    // Animation duration (default 250)
    showItemDuration: Duration(milliseconds: 300),


    // Animations starts at 0.05 visible
    // item fraction in sight (default 0.025)
    visibleFraction: 0.025,

    // Repeat the animation of the appearance
    // when scrolling in the opposite direction (default false)
    // To get the effect as in a showcase for ListView, set true
    reAnimateOnVisibility: false,
  );

  TextEditingController pushUpNameController = TextEditingController();
  TextEditingController pushUpDurationController = TextEditingController();
  TextEditingController pushUpRepsController = TextEditingController();

  void _showAction(BuildContext context, int index) async {
    switch(index) {

      case 0: // Runs
        navBarselectedIndex = 1;
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

      case 1: // Push ups
        await showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          backgroundColor: Colors.white54.withOpacity(0.9),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0)
            ),
          ),
          builder: (BuildContext context) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: const AddPushUpScreen(),
              ),
            );
          },
        );
        break;


      case 2: // Sit ups
        await showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          backgroundColor: Colors.white54.withOpacity(0.9),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0)
            ),
          ),
          builder: (BuildContext context) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: const AddSitUpScreen(),
              ),
            );
          },
        );
        break;

      case 3: // ippt training
        await showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          backgroundColor: Colors.white54.withOpacity(0.9),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0)
            ),
          ),
          builder: (BuildContext context) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: const AddIPPTScreen(),
              ),
            );
          },
        );
        break;

      default:
        break;
    }
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      bottomNavigationBar: const BottomNavBar(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Activities',
          style: TextStyle(
            color: Colors.white
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.filter_alt,
              color: Color.fromARGB(255, 180, 180, 180),
            ),
            onPressed: () {
              showAlertDialog(context, refresh);
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      floatingActionButton: ExpandableFab(
        distance: 112.0,
        children: [
          ActionButton(
            onPressed: () => _showAction(context, 0),
            icon: const Icon(Icons.directions_run),
          ),
          ActionButton(
            onPressed: () => _showAction(context, 1),
            icon: const Icon(MyFlutterApp.push_ups1, size: 25),
          ),
          ActionButton(
            onPressed: () => _showAction(context, 2),
            icon: const Icon(MyFlutterApp.sit_ups, size: 23),
          ),
          ActionButton(
            onPressed: () => _showAction(context, 3),
            icon: const Icon(Icons.fact_check_outlined, size: 26),
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: FutureBuilder(
                  future: Future.wait([
                    RunService().fetchRuns(context, user.email),
                    PushUpService().fetchPushUps(context, user.email),
                    IpptService().fetchIpptTraining(context, user.email),
                    SitUpService().fetchSitUps(context, user.email),
                  ]),
                  builder: (context, AsyncSnapshot<List<List<dynamic>>> snapshot) {
                    if (snapshot.hasData) {

                      // prevent repetitive stacking of exercise listTile after hot reloading
                      if (exercisesObjectsList.isEmpty) {
                        for (RunExercise runs in snapshot.data![0]) {
                          exercisesObjectsList.add(runs);
                        }

                        for (PushUpExercise pushups in snapshot.data![1]) {
                          exercisesObjectsList.add(pushups);
                        }

                        for (IpptTraining ippt in snapshot.data![2]) {
                          exercisesObjectsList.add(ippt);
                        }

                        for (SitUpExercise situps in snapshot.data![3]) {
                          exercisesObjectsList.add(situps);
                        }

                        // sort exercises in listview by latest datetime
                        exercisesObjectsList.sort((a,b) => a.dateTime.compareTo(b.dateTime));
                        exercisesObjectsList = exercisesObjectsList.reversed.toList();
                      }

                      return LiveList.options(
                        options: options,
                        itemCount: exercisesObjectsList.length,
                        itemBuilder: (BuildContext context, int index, Animation<double> animation) {
                          switch(exercisesObjectsList[index].type) {
                            case 'run':
                              return filterValues[0] ? FadeTransition(
                                opacity: Tween<double>(
                                  begin: 0,
                                  end: 1,
                                ).animate(animation),
                                // And slide transition
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, -0.1),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  // Paste you Widget
                                  child: Dismissible(
                                    key: UniqueKey(),
                                    onDismissed: (_) async {
                                      exercisesObjectsList.removeAt(index);
                                      await RunService().removeRun(context, exercisesObjectsList[index].id);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.5),
                                      child: Card(
                                        elevation: 3,
                                        color: const Color.fromARGB(255, 23, 23, 23).withOpacity(0.6),
                                        child: ListTile(
                                          leading: const Icon(
                                              Icons.directions_run,
                                              size: 40,
                                              color: Colors.orangeAccent
                                          ),

                                          title: Text(
                                            exercisesObjectsList[index].name,
                                            style: const TextStyle(color: Colors.white, fontSize: 17),
                                          ),
                                          subtitle: Text(
                                            DateFormat('MMM dd')
                                                .format(DateFormat('y-MM-ddTHH:mm:ss.SSSZ')
                                                .parse(exercisesObjectsList[index].dateTime.toString()))
                                                + ', '
                                                + DateFormat('hh:mm a')
                                                .format(DateFormat('y-MM-ddTHH:mm:ss.SSSZ')
                                                .parse(exercisesObjectsList[index].dateTime.toString())),
                                            style: const TextStyle(color: Colors.white),
                                          ),

                                          trailing: Wrap(
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      double.parse(exercisesObjectsList[index].distance).toStringAsFixed(2) + ' km',
                                                      style: const TextStyle(color: Color.fromARGB(255, 211, 186, 109), fontSize: 20),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [

                                                        Text(
                                                          DateFormat('mm:ss')
                                                              .format(DateFormat('HH:mm:ss')
                                                              .parse(exercisesObjectsList[index].timing.toString())),
                                                          style: const TextStyle(color: Color.fromARGB(255, 180, 180, 180), fontSize: 13.5),
                                                        ),
                                                        //const SizedBox(width: 1),
                                                        //const Icon(Icons.access_time_rounded, size: 16, color: Color.fromARGB(255, 211, 186, 109),),

                                                      ],
                                                    ),
                                                  ],
                                                )
                                              ]
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ) : const SizedBox(height: 0);
                            case 'pushup':
                              return filterValues[1] ? FadeTransition(
                                opacity: Tween<double>(
                                  begin: 0,
                                  end: 1,
                                ).animate(animation),
                                // And slide transition
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, -0.1),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  // Paste you Widget
                                  child: Dismissible(
                                    key: UniqueKey(),
                                    onDismissed: (_) async {
                                      exercisesObjectsList.removeAt(index);
                                      await PushUpService().removePushUp(context, exercisesObjectsList[index].id);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.5),
                                      child: Card(
                                        elevation: 3,
                                        color: const Color.fromARGB(255, 23, 23, 23).withOpacity(0.6),
                                        child: ListTile(
                                          leading: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: const [
                                              SizedBox(height: 5),
                                              Icon(
                                                  MyFlutterApp.push_ups1,
                                                  size: 35,
                                                  color: Colors.lightBlueAccent
                                              ),
                                            ],
                                          ),

                                          title: Text(
                                            exercisesObjectsList[index].name,
                                            style: const TextStyle(color: Colors.white, fontSize: 17),
                                          ),
                                          subtitle: Text(
                                            DateFormat('MMM dd')
                                                .format(DateFormat('y-MM-ddTHH:mm:ss.SSSZ')
                                                .parse(exercisesObjectsList[index].dateTime.toString()))
                                                + ', '
                                                + DateFormat('hh:mm a')
                                                .format(DateFormat('y-MM-ddTHH:mm:ss.SSSZ')
                                                .parse(exercisesObjectsList[index].dateTime.toString())),
                                            style: const TextStyle(color: Colors.white),
                                          ),

                                          trailing: Wrap(
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      exercisesObjectsList[index].reps + ' reps',
                                                      style: const TextStyle(color: Color.fromARGB(255, 211, 186, 109), fontSize: 20),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      _printDuration(exercisesObjectsList[index].timing),
                                                      style: const TextStyle(color: Color.fromARGB(255, 180, 180, 180), fontSize: 13.5),
                                                    ),
                                                  ],
                                                )
                                              ]
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ) : const SizedBox(height: 0);
                            case 'situp':
                              return filterValues[2] ? FadeTransition(
                                opacity: Tween<double>(
                                  begin: 0,
                                  end: 1,
                                ).animate(animation),
                                // And slide transition
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, -0.1),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  // Paste you Widget
                                  child: Dismissible(
                                    key: UniqueKey(),
                                    onDismissed: (_) async {
                                      exercisesObjectsList.removeAt(index);
                                      await SitUpService().removeSitUp(context, exercisesObjectsList[index].id);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.5),
                                      child: Card(
                                        elevation: 3,
                                        color: const Color.fromARGB(255, 23, 23, 23).withOpacity(0.6),
                                        child: ListTile(
                                          leading: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: const [
                                              SizedBox(height: 5),
                                              Icon(
                                                  MyFlutterApp.sit_ups,
                                                  size: 35,
                                                  color: Colors.yellowAccent
                                              ),
                                            ],
                                          ),

                                          title: Text(
                                            exercisesObjectsList[index].name,
                                            style: const TextStyle(color: Colors.white, fontSize: 17),
                                          ),
                                          subtitle: Text(
                                            DateFormat('MMM dd')
                                                .format(DateFormat('y-MM-ddTHH:mm:ss.SSSZ')
                                                .parse(exercisesObjectsList[index].dateTime.toString()))
                                                + ', '
                                                + DateFormat('hh:mm a')
                                                .format(DateFormat('y-MM-ddTHH:mm:ss.SSSZ')
                                                .parse(exercisesObjectsList[index].dateTime.toString())),
                                            style: const TextStyle(color: Colors.white),
                                          ),

                                          trailing: Wrap(
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      exercisesObjectsList[index].reps + ' reps',
                                                      style: const TextStyle(color: Color.fromARGB(255, 211, 186, 109), fontSize: 20),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      _printDuration(exercisesObjectsList[index].timing),
                                                      style: const TextStyle(color: Color.fromARGB(255, 180, 180, 180), fontSize: 13.5),
                                                    ),
                                                  ],
                                                )
                                              ]
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ) : const SizedBox(height: 0);
                            case 'ippt':
                              return filterValues[3] ? FadeTransition(
                                opacity: Tween<double>(
                                  begin: 0,
                                  end: 1,
                                ).animate(animation),
                                // And slide transition
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, -0.1),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  // Paste you Widget
                                  child: Dismissible(
                                    key: UniqueKey(),
                                    onDismissed: (_) async {
                                      exercisesObjectsList.removeAt(index);
                                      await IpptService().removeIpptTraining(context, exercisesObjectsList[index].id);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.5),
                                      child: Card(
                                        elevation: 3,
                                        color: const Color.fromARGB(255, 23, 23, 23).withOpacity(0.6),
                                        child: ExpansionTile(
                                          iconColor: const Color.fromARGB(255, 211, 186, 109),
                                          collapsedIconColor: const Color.fromARGB(255, 200, 200, 200),
                                          leading: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const SizedBox(height: 2),
                                              Icon(
                                                Icons.fact_check_outlined,
                                                size: 38,
                                                color: Colors.lightGreenAccent.shade700,
                                              ),
                                            ],
                                          ),
                                          title: Text(
                                            exercisesObjectsList[index].name,
                                            style: const TextStyle(color: Colors.white, fontSize: 17),
                                          ),
                                          subtitle: Text(
                                            DateFormat('MMM dd')
                                                .format(DateFormat('y-MM-ddTHH:mm:ss.SSSZ')
                                                .parse(exercisesObjectsList[index].dateTime.toString()))
                                                + ', '
                                                + DateFormat('hh:mm a')
                                                .format(DateFormat('y-MM-ddTHH:mm:ss.SSSZ')
                                                .parse(exercisesObjectsList[index].dateTime.toString())),
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                          trailing: Wrap(
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      exercisesObjectsList[index].score + ' pts',
                                                      style: const TextStyle(color: Color.fromARGB(255, 211, 186, 109), fontSize: 20),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    const Text(
                                                      'Tap to view details',
                                                      style: TextStyle(color: Color.fromARGB(255, 180, 180, 180), fontSize: 13.5),
                                                    ),
                                                  ],
                                                )
                                              ]
                                          ),
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.fromLTRB(30, 0, 30, 7),
                                              child: Divider(
                                                color: Color.fromARGB(255, 80, 80, 80),
                                                thickness: 1,
                                              ),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      const Icon(
                                                          MyFlutterApp.push_ups1,
                                                          size: 35,
                                                          color: Color.fromARGB(255, 180, 180, 180)
                                                      ),
                                                      const Text('1 min', style: TextStyle(color: Color.fromARGB(255, 180, 180, 180))),
                                                      const SizedBox(height: 6),
                                                      Text(
                                                          exercisesObjectsList[index].pushupReps + ' reps',
                                                          style: const TextStyle(
                                                            color: Color.fromARGB(255, 211, 186, 109),
                                                            fontSize: 16,
                                                          )
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      const Icon(
                                                          MyFlutterApp.sit_ups,
                                                          size: 35,
                                                          color: Color.fromARGB(255, 180, 180, 180)
                                                      ),
                                                      const Text('1 min', style: TextStyle(color: Color.fromARGB(255, 180, 180, 180))),
                                                      const SizedBox(height: 6),
                                                      Text(
                                                          exercisesObjectsList[index].situpReps + ' reps',
                                                          style: const TextStyle(
                                                            color: Color.fromARGB(255, 211, 186, 109),
                                                            fontSize: 16,
                                                          )
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      const Icon(
                                                          Icons.directions_run,
                                                          size: 35,
                                                          color: Color.fromARGB(255, 180, 180, 180)
                                                      ),
                                                      const Text('2.4 km', style: TextStyle(color: Color.fromARGB(255, 180, 180, 180))),
                                                      const SizedBox(height: 6),
                                                      Text(
                                                          _printDuration(exercisesObjectsList[index].runTiming),
                                                          style: const TextStyle(
                                                            color: Color.fromARGB(255, 211, 186, 109),
                                                            fontSize: 16,
                                                          )
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),
                                            const SizedBox(height: 15),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ) : const SizedBox(height: 0);
                            default:
                              return const SizedBox(height: 0);
                          }
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




    