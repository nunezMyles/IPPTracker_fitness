import 'package:flutter/material.dart';
import 'package:my_fitness/screens/spotify_screen.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../my_flutter_app_icons.dart';
import '../widgets/bottomNavBar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:location/location.dart';
import '../widgets/showSnackBar.dart';
import '../models/run_exercise.dart';
import '../utilities/run_service.dart';

import '../screens/home_screen.dart';
import 'add_run_screen.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

// preserve values when user navigates to different page - to continuously track time, distance travelled
bool recordStarted = false;

int time = 0;
double dist = 0;
int lastTime = 0;
double speed = 0;
double avgSpeed = 0;
int speedCounter = 0;
String displayTime = '';
String savedDisplayTime = '00:00:00';

List<LatLng> route = [];
final Set<Polyline> polyline = {};
LatLng center = const LatLng(1.3521, 103.8198); // Map view starts w/ Singapore coords

bool isLocationOn = false;
final Location location = Location();
StopWatchTimer stopWatchTimer = StopWatchTimer();

class _MapScreenState extends State<MapScreen> with AutomaticKeepAliveClientMixin{
  late GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    stopWatchTimer.dispose(); // release memory
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true; // preserve widget state when navigating to different page

  _locationInit(BuildContext context) async {
    bool serviceEnabled;
    geo.LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) { // will always check if device loc is on
      if (isLocationOn) {
        setState(() {
          isLocationOn = false; // if device loc is off and app loc shows on, turn app loc off
        });
      }
      showSnackBar(context, 'Location services are disabled.');
      return;
    }

    if (isLocationOn) { // if device loc is on and app loc is on, return, do nothing
      return;
    }

    permission = await geo.Geolocator.checkPermission();
    if (permission == geo.LocationPermission.denied) {
      permission = await geo.Geolocator.requestPermission();
      if (permission == geo.LocationPermission.denied) {
        showSnackBar(context, 'Location permissions are denied');
        return;
      }
      return;
    }

    if (permission == geo.LocationPermission.deniedForever) {
      showSnackBar(context, 'Location permissions are permanently denied, we cannot request permissions.');
      return;
    }

    setState(() {
      isLocationOn = true;  // if device loc is on and app loc is off, turn app loc on
    });
    _goToCurrentLoc();
  }

  _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    double appendDist;

    location.onLocationChanged.listen((event) {
      LatLng loc = LatLng(event.latitude!, event.longitude!);
      center = loc;

      // continuously return to current location only after User has started running
      if (recordStarted) {
        _mapController.animateCamera(
            CameraUpdate.newCameraPosition(
                CameraPosition(target: loc, zoom: 18)
            )
        );
      }

      if (route.isNotEmpty) {
        appendDist = geo.Geolocator.distanceBetween(
            route.last.latitude,
            route.last.longitude,
            loc.latitude,
            loc.longitude
        );
        dist = dist + appendDist;
        int timeDuration = (time - lastTime);

        if (timeDuration != 0) {
          speed = (appendDist / (timeDuration / 100)) * 3.6;
          if (speed != 0) {
            avgSpeed = avgSpeed + speed;
            speedCounter++;
          }
        }
      }

      lastTime = time;

      if (recordStarted) {
        route.add(loc);

        polyline.add(Polyline(
            polylineId: PolylineId(event.toString()),
            visible: true,
            points: route,
            width: 5,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
            color: Colors.deepOrange
        ));
      }

      setState(() {});
    });
  }

  _goToCurrentLoc() async {
    await geo.Geolocator.getCurrentPosition().then((value) {
      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(value.latitude, value.longitude), zoom: 18),
        ),
      );
    });
  }


  @override
  Widget build(BuildContext context) {

    super.build(context);

    _locationInit(context);

    return Scaffold(
      bottomNavigationBar: const BottomNavBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 45.0,
            width: 45.0,
            child: FittedBox(
              child: FloatingActionButton(
                heroTag: "current_location_btn", // hero tag to resolve 'multiple heroes' error
                backgroundColor: const Color.fromARGB(255, 23, 23, 23).withOpacity(0.8),
                child: const Icon(Icons.my_location, color: Colors.white, size: 30,),
                onPressed: () {
                  _goToCurrentLoc();
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 45.0,
            width: 45.0,
            child: FittedBox(
              child: FloatingActionButton(
                heroTag: "spotify_btn", // hero tag to resolve 'multiple heroes' error
                backgroundColor: const Color.fromARGB(255, 23, 23, 23).withOpacity(0.8),
                child: const Icon(MyFlutterApp.spotify, color: Colors.green, size: 37,),
                onPressed: () async {
                  await showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    backgroundColor: const Color.fromARGB(255, 23, 23, 23).withOpacity(0.9),
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
                          child: const SpotifyScreen(),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Record Trail Run',
          style: TextStyle(
              color: Colors.white
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: isLocationOn
                ? const Icon(Icons.location_on, color: Colors.green, size: 30)
                : const Icon(Icons.location_off, color: Colors.deepOrangeAccent, size: 30),
            onPressed: () async {
              await SpotifySdk.disconnect();
            },
          ),
        ],
      ),
      body: Stack(
          children: [
            GoogleMap(
              polylines: polyline,
              zoomControlsEnabled: false,
              buildingsEnabled: false,
              onMapCreated: _onMapCreated,
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(target: center, zoom: 22),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 40),
                  height: 140,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 23, 23, 23).withOpacity(0.85),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              const Text(
                                "Speed (km/h)",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                              ),
                              Text(
                                speed.toStringAsFixed(2),
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              const Text(
                                "Time",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                              ),
                              StreamBuilder<int>(
                                stream: stopWatchTimer.rawTime,
                                initialData: 0,
                                builder: (context, snapshot) {
                                  time = snapshot.data!;
                                  displayTime = StopWatchTimer.getDisplayTimeHours(time)
                                      + ":"
                                      + StopWatchTimer.getDisplayTimeMinute(time)
                                      + ":"
                                      + StopWatchTimer.getDisplayTimeSecond(time);
                                  return Text(
                                    displayTime,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                          Column(
                            children: [
                              const Text(
                                "Distance (km)",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                              ),
                              Text(
                                (dist / 1000).toStringAsFixed(2),
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.all(2.5),
                        child: Divider(
                          color: Color.fromARGB(255, 110, 110, 110),
                          thickness: 2,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Material(
                              color: Colors.transparent,
                              child: IconButton(
                                splashRadius: 27,
                                icon: Icon(
                                  recordStarted ? Icons.stop_circle_outlined : Icons.play_circle_outline,
                                  size: 50,
                                  color: recordStarted ? Colors.redAccent : const Color.fromARGB(255, 211, 186, 109),
                                ),
                                padding: const EdgeInsets.all(0),
                                onPressed: () async {
                                  if (!recordStarted) {
                                    setState(() {
                                      recordStarted = true;
                                      stopWatchTimer.onStartTimer();
                                    });
                                  } else {
                                    setState(() async {
                                      recordStarted = false;

                                      // save display time before timer reset since above streambuilder will reset displayTime immediately
                                      savedDisplayTime = displayTime;
                                      stopWatchTimer.onResetTimer();

                                      // display 'add run' screen using bottomSheet
                                      await showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        backgroundColor: Colors.white,
                                        builder: (BuildContext context) {
                                          return SingleChildScrollView(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context).viewInsets.bottom),
                                              child: const AddRunScreen(),
                                            ),
                                          );
                                        },
                                      );

                                      // force a value into runNameController
                                      if (runNameController.text.isEmpty) {
                                        runNameController.text = 'Unnamed entry';
                                      }

                                      // create new Run Entry object to send to DB
                                      RunExercise runEntry = RunExercise(
                                          id: '',
                                          name: runNameController.text.toString(),
                                          email: user.email,
                                          timing: savedDisplayTime,
                                          distance: (dist / 1000).toStringAsFixed(2).toString(),
                                          dateTime: '',
                                          type: ''
                                        // speed: speed: _speedCounter == 0 ? 0 : _avgSpeed / _speedCounter,
                                      );

                                      // call createRun() API to send newly created object to DB
                                      await RunService().createRun(context, runEntry);

                                      // reset values
                                      dist = 0;
                                      time = 0;
                                      speed = 0;
                                      avgSpeed = 0;
                                      lastTime = 0;
                                      speedCounter = 0;
                                      center = const LatLng(1.3521, 103.8198);

                                      route = [];
                                      polyline.clear();

                                      runNameController.text = '';
                                      displayTime = '00:00:00';

                                      // navigate to activity screen
                                      navBarselectedIndex = 0;
                                      await Navigator.push(context, PageRouteBuilder(
                                        pageBuilder: (
                                            BuildContext context,
                                            Animation<double> animation,
                                            Animation<double> secondaryAnimation
                                            ) => const HomeScreen(),
                                        transitionDuration: const Duration(milliseconds: 250),
                                        transitionsBuilder: (
                                            BuildContext context,
                                            Animation<double> animation,
                                            Animation<double> secondaryAnimation,
                                            Widget child,) => FadeTransition(opacity: animation, child: child),
                                      ));
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
            )
          ]
      )
    );
  }
}

