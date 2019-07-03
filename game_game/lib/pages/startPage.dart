import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter_testuu/Themes/MasterTheme.dart';
import '../Globals.dart';
import '../radialMenu.dart';

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  GeolocationStatus geolocationStatus;
  Position currentPos;

  bool positionDataOk = false;

  @override
  void initState() async {
    super.initState();
    geolocationStatus = await Geolocator().checkGeolocationPermissionStatus();
    if (geolocationStatus.value != 2) {
      //check if location status is anything but granted
      positionDataOk = false;
    } else {
      //geolocation status is ok
      updateCurrentLocation();
      positionDataOk = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Global.intializeValues(
        MediaQuery.of(context).size.width,
        MediaQuery.of(context)
            .size
            .width); //update the screensizes for the global values class
    if (positionDataOk) {
      return WillPopScope(
        //onwill popscope disables the use of the android back button
        onWillPop: () async => false,
        child: Theme(
          data: MasterTheme.mainTheme,
          child: Scaffold(
            body: ListView(
              children: <Widget>[
                Text('Location services are enabled'),
              ],
            ),
          ),
        ),
      );
    } else {
      return WillPopScope(
        //onwill popscope disables the use of the android back button
        onWillPop: () async => false,
        child: Theme(
          data: MasterTheme.mainTheme,
          child: Scaffold(
            body: ListView(
              children: <Widget>[
                Text('Location services are disabled'),
              ],
            ),
          ),
        ),
      );
    }
  }

  void updateCurrentLocation() async {
    //update the current location
    currentPos = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}
