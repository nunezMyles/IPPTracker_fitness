import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../utilities/account_service.dart';
import '../widgets/bottomNavBar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:location/location.dart';
import '../widgets/showSnackBar.dart';
import '../models/run_exercise.dart';
import '../utilities/run_service.dart';

import '../screens/home_screen.dart';
import 'add_run_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

// preserve values when user navigates to different page - to continuously track time, distance travelled
bool recordStarted = false;

double _dist = 0;

int _time = 0;
int _lastTime = 0;
double _speed = 0;
double _avgSpeed = 0;
int _speedCounter = 0;
String _displayTime = '';

List<LatLng> route = [];
final Set<Polyline> polyline = {};

final Location _location = Location();
StopWatchTimer stopWatchTimer = StopWatchTimer();
LatLng _center = const LatLng(1.3521, 103.8198); // Map view starts w/ Singapore coords


class _MapScreenState extends State<MapScreen> with AutomaticKeepAliveClientMixin{
  late GoogleMapController _mapController;

  _locationInit(BuildContext context) async {
    bool serviceEnabled;
    geo.LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      showSnackbar(context, 'Location services are disabled.');
    }

    permission = await geo.Geolocator.checkPermission();

    if (permission == geo.LocationPermission.denied) {
      permission = await geo.Geolocator.requestPermission();
      if (permission == geo.LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        showSnackbar(context, 'Location permissions are denied');
      } else {
        setState(() { // reload widget to display 'go to current location' button

        });
      }
    }

    if (permission == geo.LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      showSnackbar(context, 'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    /*return await geo.Geolocator.getCurrentPosition(
      desiredAccuracy: geo.LocationAccuracy.bestForNavigation,
      forceAndroidLocationManager: true,
    ).timeout(const Duration(seconds: 20));*/
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    //if (!recordStarted) await stopWatchTimer.dispose();
  }

  @override
  bool get wantKeepAlive => true; // preserve widget state when navigating to different page

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    double appendDist;

    _location.onLocationChanged.listen((event) {
      LatLng loc = LatLng(event.latitude!, event.longitude!);
      //print(event.latitude.toString() + ' , ' + event.longitude.toString());
      _center = loc;

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
        //print(appendDist.toString() + '========================================================');
        _dist = _dist + appendDist;
        //print(_dist.toString() + '==================================================================');
        int timeDuration = (_time - _lastTime);

        if (timeDuration != 0) {
          _speed = (appendDist / (timeDuration / 100)) * 3.6;
          if (_speed != 0) {
            _avgSpeed = _avgSpeed + _speed;
            _speedCounter++;
          }
        }
      }

      _lastTime = _time;

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

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _locationInit(context);

    return Scaffold(
      bottomNavigationBar: const BottomNavBar(),
      appBar: AppBar(
        title: const Text(
          'Map',
          style: TextStyle(
              color: Color.fromARGB(255, 179, 161, 79)
          ),),
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
      body: Stack(
          children: [
            GoogleMap(
              polylines: polyline,
              zoomControlsEnabled: false,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(target: _center, zoom: 22),
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
                                _speed.toStringAsFixed(2),
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
                                  _time = snapshot.data!;
                                  _displayTime = StopWatchTimer.getDisplayTimeHours(_time)
                                      + ":"
                                      + StopWatchTimer.getDisplayTimeMinute(_time)
                                      + ":"
                                      + StopWatchTimer.getDisplayTimeSecond(_time);
                                  return Text(
                                    _displayTime,
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
                                (_dist / 1000).toStringAsFixed(2),
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
                      IconButton(
                        icon: Icon(
                          recordStarted ? Icons.stop_circle_outlined : Icons.play_circle_outline,
                          size: 50,
                          color: recordStarted ? Colors.redAccent : Colors.greenAccent,
                        ),
                        padding: const EdgeInsets.all(0),
                        onPressed: () {
                          if (!recordStarted) {
                            setState(() {
                              recordStarted = true;
                              stopWatchTimer.onStartTimer();
                            });
                          } else {
                            setState(() async {
                              recordStarted = false;
                              stopWatchTimer.onResetTimer();

                              // display 'add run' screen using bottomSheet
                              await showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
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
                                  timing: _displayTime,
                                  distance: (_dist / 1000).toStringAsFixed(2).toString(),
                                  dateTime: '',
                                  type: ''
                                  // speed: speed: _speedCounter == 0 ? 0 : _avgSpeed / _speedCounter,
                              );

                              // call createRun() API to send newly created object to DB
                              RunService().createRun(context, runEntry);

                              // reset values
                              _dist = 0;
                              _displayTime = '00:00:00';
                              _time = 0;
                              _lastTime = 0;
                              _speed = 0;
                              _avgSpeed = 0;
                              _speedCounter = 0;
                              _center = const LatLng(1.3521, 103.8198);

                              route = [];
                              polyline.clear();

                              runNameController.text = '';

                              // navigate to activity screen
                              navBarselectedIndex = 0;
                              Navigator.pushReplacementNamed(context, '/home');
                            });
                          }
                        },
                      )
                    ],
                  ),
                )
            )
          ]
      )
    );
  }
}

