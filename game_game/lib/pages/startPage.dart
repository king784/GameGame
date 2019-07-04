import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  Widget build(BuildContext context) {
    Global.intializeValues(
        MediaQuery.of(context).size.width,
        MediaQuery.of(context)
            .size
            .width); //update the screensizes for the global values class

    //ask for location permission and check the state of permission after
    updateCurrentLocation();
    checkGeolocationStatus();

    if (positionDataOk) {
      return WillPopScope(
        //onwill popscope disables the use of the android back button
        onWillPop: () async => false,
        child: Theme(
          data: MasterTheme.mainTheme,
          child: Scaffold(
            body: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 100, 20, 10),
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
                          child: Text(
                            'Syötä pelikoodi:',
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.subtitle,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'esim. XQ34H',
                              prefixStyle: Theme.of(context).textTheme.display1,
                              labelStyle: Theme.of(context).textTheme.subhead,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: MaterialButton(
                            onPressed: () {},
                            color: MasterTheme.accentColour,
                            padding: EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text("Tarkista"),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Icon(FontAwesomeIcons.arrowRight),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(40),
                  child: MaterialButton(
                    onPressed: () {},
                    color: MasterTheme.bgBoxColour,
                    padding: EdgeInsets.all(2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("Näytä vain omat tietoni",
                            style: Theme.of(context).textTheme.body1),
                      ],
                    ),
                  ),
                ),
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

  void checkGeolocationStatus() async {
    geolocationStatus = await Geolocator().checkGeolocationPermissionStatus();
    print('Geolocation status: ' + geolocationStatus.value.toString());
    if (geolocationStatus.value != 2) {
      //check if location status is anything but granted
      positionDataOk = false;
    } else {
      positionDataOk = true;
    }
    setState(() {});
  }
}
