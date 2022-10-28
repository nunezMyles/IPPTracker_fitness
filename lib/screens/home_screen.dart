import 'package:flutter/material.dart';
import 'package:my_fitness/models/pushup_exercise.dart';
import 'package:my_fitness/models/run_exercise.dart';
import 'package:my_fitness/my_flutter_app_icons.dart';
import 'package:my_fitness/screens/add_pushup_screen.dart';
import 'package:my_fitness/utilities/account_service.dart';
import 'package:my_fitness/utilities/pushup_service.dart';
import 'package:my_fitness/utilities/run_service.dart';
import 'package:my_fitness/widgets/bottomNavBar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:auto_animated/auto_animated.dart';
import 'dart:math' as math;

import '../providers/user_provider.dart';
import 'map_screen.dart';

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
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
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

  static const _actionTitles = ['', 'Add Push-ups', 'Add Sit-ups'];

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
        showDialog<void>(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(_actionTitles[index]),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('CLOSE'),
                ),
              ],
            );
          },
        );
        break;

      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      bottomNavigationBar: const BottomNavBar(),
      appBar: AppBar(
        leadingWidth: 10,
        title: const Text(
          'Activities',
          style: TextStyle(
            color: Colors.white
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
                AccountService().logOut(context);
              });
            },
          )
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
        ],
      ),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: FutureBuilder(
                  future: Future.wait([RunService().fetchRuns(context, user.email), PushUpService().fetchPushUps(context, user.email)]),
                  builder: (context, AsyncSnapshot<List<List<dynamic>>> snapshot) {
                    if (snapshot.hasData) {

                      // prevent continuous exercise add to list after hot reloading
                      if (exercisesObjectsList.isEmpty) {
                        for (RunExercise runs in snapshot.data![0]) {
                          exercisesObjectsList.add(runs);
                        }

                        for (PushUpExercise pushups in snapshot.data![1]) {
                          exercisesObjectsList.add(pushups);
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
                              return FadeTransition(
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
                                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                                                          exercisesObjectsList[index].timing,
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
                              );
                            /*case 'pushup':
                              return FadeTransition(
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
                                              SizedBox(height: 5,),
                                              Icon(
                                                  MyFlutterApp.push_ups1,
                                                  size: 32,
                                                  color: Colors.lightBlueAccent
                                              ),
                                            ],
                                          ),

                                          title: Text(
                                            exercisesObjectsList[index].name,
                                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                              );
                            */case 'pushup':
                              return FadeTransition(
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
                                      await PushUpService().removePushUp(context, exercisesObjectsList[index].id);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.5),
                                      child: Card(
                                        elevation: 3,
                                        color: const Color.fromARGB(255, 23, 23, 23).withOpacity(0.6),
                                        child: ExpansionTile(
                                          iconColor: const Color.fromARGB(255, 211, 186, 109),
                                          collapsedIconColor: const Color.fromARGB(255, 180, 180, 180),
                                          leading: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: const [
                                              SizedBox(height: 5,),
                                              Icon(
                                                  Icons.fact_check_outlined,
                                                  size: 36,
                                                  color: Colors.lightBlueAccent
                                              ),
                                            ],
                                          ),
                                          title: Text(
                                            exercisesObjectsList[index].name,
                                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                                          children: [
                                            const Text('jinds'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            default:
                              return const SizedBox(height: 1);
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

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    Key? key,
    this.initialOpen,
    required this.distance,
    required this.children
  }) : super(key: key);

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

// for initial FAB + cancel button
class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56.0,
      height: 56.0,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          color: Colors.white.withOpacity(0.9),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: InkWell(
            onTap: _toggle,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.close,
                color: Colors.redAccent,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);
    for (var i = 0, angleInDegrees = 0.0;
    i < count;
    i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            onPressed: _toggle,
            child: const Icon(Icons.add, size: 30,),
            backgroundColor: const Color.fromARGB(255, 23, 23, 23),
            foregroundColor: Colors.greenAccent,
          ),
        ),
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  });

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

// for each of the 3 action buttons
@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    Key? key,
    this.onPressed,
    required this.icon,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: Colors.black.withOpacity(0.5),
      elevation: 4.0,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        color: Colors.greenAccent,
      ),
    );
  }
}

@immutable
class FakeItem extends StatelessWidget {
  const FakeItem({
    Key? key,
    required this.isBig,
  }) : super(key: key);

  final bool isBig;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      height: isBig ? 128.0 : 36.0,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        color: Colors.grey.shade300,
      ),
    );
  }
}



    