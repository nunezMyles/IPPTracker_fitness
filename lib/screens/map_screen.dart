import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../utilities/account_service.dart';
import '../widgets/bottom_navBar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:location/location.dart';
import '../widgets/showSnackBar.dart';
import '../models/run_entry.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LatLng _center = const LatLng(0, 0);
  final Location _location = Location();
  late GoogleMapController _mapController;

  List<LatLng> route = [];
  final Set<Polyline> polyline = {};

  bool recordStarted = false;

  double _dist = 0;
  late String _displayTime;
  int _time = 0;
  int _lastTime = 0;
  double _speed = 0;
  double _avgSpeed = 0;
  int _speedCounter = 0;

  //final Completer<GoogleMapController> _controller = Completer();
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  Future<geo.Position> _determinePosition(BuildContext context) async {
    bool serviceEnabled;
    geo.LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      showSnackbar(context, 'Location services are disabled.');
      //await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
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
        return Future.error('Location permissions are denied');
      } else {
        setState(() { // reload widget to show 'go to current location' button

        });
      }
    }

    if (permission == geo.LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      showSnackbar(context, 'Location permissions are permanently denied, we cannot request permissions.');
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await geo.Geolocator.getCurrentPosition(
      desiredAccuracy: geo.LocationAccuracy.bestForNavigation,
      forceAndroidLocationManager: true,
    ).timeout(const Duration(seconds: 20));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() async {
    //_mapController.dispose();
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    double appendDist;


    _location.onLocationChanged.listen((event) {
      LatLng loc = LatLng(event.latitude!, event.longitude!);

      _mapController.animateCamera(
          CameraUpdate.newCameraPosition(
              CameraPosition(target: loc, zoom: 18)
          )
      );

      if (route.isNotEmpty) {
        appendDist = geo.Geolocator.distanceBetween(
            route.last.latitude,
            route.last.longitude,
            loc.latitude,
            loc.longitude
        );
        _dist = _dist + appendDist;
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

    _determinePosition(context);

    return Scaffold(
      bottomNavigationBar: const BottomNavBar(),
      appBar: AppBar(
        title: const Text('Map'),
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
      body: Stack(
          children: [
            GoogleMap(
              polylines: polyline,
              zoomControlsEnabled: false,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(target: _center, zoom: 40),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 40),
                  height: 140,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(10)),
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
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(
                                _speed.toStringAsFixed(2),
                                style: const TextStyle(
                                    fontSize: 20
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              const Text(
                                "Time",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              StreamBuilder<int>(
                                stream: _stopWatchTimer.rawTime,
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
                                        fontSize: 20
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
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(
                                (_dist / 1000).toStringAsFixed(2),
                                style: const TextStyle(
                                  fontSize: 20
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Divider(),
                      ),
                      IconButton(
                        icon: Icon(
                          recordStarted ? Icons.stop_circle_outlined : Icons.play_circle_outline,
                          size: 50,
                          color: recordStarted ? Colors.red : Colors.lightBlueAccent,
                        ),
                        padding: const EdgeInsets.all(0),
                        onPressed: () async {
                          if (!recordStarted) {
                            _stopWatchTimer.onStartTimer();

                            setState(() {
                              recordStarted = true;
                            });

                          } else {
                            _stopWatchTimer.onResetTimer();

                            Entry entry = Entry(
                                id: 0,
                                date: '22/10/2022',
                                duration: _displayTime,
                                speed: _speedCounter == 0
                                    ? 0
                                    : _avgSpeed / _speedCounter,
                                distance: _dist
                            );

                            setState(() {
                              _dist = 0;
                              _displayTime = '00:00:00';
                              _time = 0;
                              _lastTime = 0;
                              _speed = 0;
                              _avgSpeed = 0;
                              _speedCounter = 0;

                              route = [];
                              polyline.clear();

                              recordStarted = false;
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
