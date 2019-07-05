import 'package:flutter/material.dart';
import 'package:flutter_testuu/StartPageForm.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter_testuu/Themes/MasterTheme.dart';
import '../Globals.dart';
import '../Navigation.dart';

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  GeolocationStatus geolocationStatus;
  Position currentPos;

  List<Placemark> placemarkEventAddress;
  List<Placemark> placemarkUserLocation;

  bool positionDataOk = false;

  @override
  void initState() {
    super.initState();
  }

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
                    child: StartPageForm(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(40),
                  child: MaterialButton(
                    onPressed: () =>
                        Navigation.openUserPageWithoutMenu(context),
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
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 100, 30, 5),
                        child: Text(
                            'Sijainti ei ole käytössä. Pystyt silti katsomaan omat tietosi',
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.caption),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 5, 30, 5),
                    child: MaterialButton(
                      onPressed: () =>
                          Navigation.openUserPageWithoutMenu(context),
                      color: MasterTheme.bgBoxColour,
                      padding: EdgeInsets.all(2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text("Tarkista omat tiedot",
                              style: Theme.of(context).textTheme.body1),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Icon(
                              FontAwesomeIcons.arrowRight,
                              size: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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

  void getEventAddressIntoPlacemark() async {
    placemarkEventAddress =
        await Geolocator().placemarkFromAddress("Heikinkatu 7, Kotka");
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
