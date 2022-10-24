import 'package:flutter/material.dart';
import 'package:my_fitness/models/run_exercise.dart';
import 'package:my_fitness/utilities/account_service.dart';
import 'package:my_fitness/utilities/run_service.dart';
import 'package:my_fitness/widgets/bottomNavBar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

import '../providers/user_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

dynamic user;

class _HomeScreenState extends State<HomeScreen> {

  static const _actionTitles = ['', 'Add Sit-ups', 'Add Push-ups'];

  void _showAction(BuildContext context, int index) {
    switch(index) {
      case 0: // Runs
        navBarselectedIndex = 1;
        Navigator.pushReplacementNamed(context, '/map');
        break;

      case 1: // Sit ups
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

      case 2: // Push ups
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
      floatingActionButton: ExpandableFab(
        distance: 112.0,
        children: [
          ActionButton(
            onPressed: () => _showAction(context, 0),
            icon: const Icon(Icons.directions_run),
          ),
          ActionButton(
            onPressed: () => _showAction(context, 1),
            icon: const Icon(Icons.fiber_dvr),
          ),
          ActionButton(
            onPressed: () => _showAction(context, 2),
            icon: const Icon(Icons.videocam),
          ),
        ],
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
                                    Icons.directions_run_rounded,
                                    size: 40,
                                    color: Colors.blue
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
                                  trailing: Wrap(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(Icons.linear_scale, size: 18, color: Colors.blueGrey,),
                                                const SizedBox(width: 8),
                                                Text(double.parse(snapshot.data![index].distance).toStringAsFixed(2) + ' km'), // 2 decimal points
                                              ],
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(Icons.access_time_rounded, size: 18, color: Colors.blueGrey,),
                                                const SizedBox(width: 8),
                                                Text(snapshot.data![index].timing),
                                              ],
                                            ),
                                            const SizedBox(height: 1),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: const [
                                                Icon(Icons.directions_run, size: 18, color: Colors.blueGrey,),
                                                SizedBox(width: 8),
                                                Text('7:15 /km'),
                                              ],
                                            )
                                          ],
                                        )
                                      ]
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

// for initial FAB + cancel button after initial FAB is expanded
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
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: InkWell(
            onTap: _toggle,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.close,
                color: Colors.blue,
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
            child: const Icon(Icons.add),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
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
      color: Colors.blueAccent,
      elevation: 4.0,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        color: Colors.white,
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



    