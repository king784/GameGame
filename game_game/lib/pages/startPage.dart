import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_testuu/StartPageForm.dart';
import 'package:flutter_testuu/UserAndLocation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter_testuu/Themes/MasterTheme.dart';
import '../Globals.dart';
import '../Navigation.dart';
import 'package:geolocator/geolocator.dart';

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  UserLocation userLoc = new UserLocation();
  Timer locationUpdateTimer;
  String messageAboutLocation = "";

  @override
  void initState() {
    initialiseUserLocationAtStart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Global.intializeValues(
        MediaQuery.of(context).size.width,
        MediaQuery.of(context)
            .size
            .width); //update the screensizes for the global values class

    //if getting user location isn't finished yet
    if (userLoc.loadingLocation) {
      return WillPopScope(
        //onwill popscope disables the use of the android back button
        onWillPop: () async => false,
        child: Theme(
          data: MasterTheme.mainTheme,
          child: Scaffold(
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Card(
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Text(
                                        'Odota, sijaintiasi päivitetään.',
                                        textAlign: TextAlign.left,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption),
                                  )
                                ],
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
        ),
      );
    }
//if location data is enabled and userlocation is close enough to event location
    else if (userLoc.userLocationOk) {
      messageAboutLocation = "Sijainti on kunnossa.";
      return WillPopScope(
        //onwill popscope disables the use of the android back button
        onWillPop: () async => false,
        child: Theme(
          data: MasterTheme.mainTheme,
          child: Scaffold(
            body: SafeArea(
              child: ListView(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(messageAboutLocation,
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.caption),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Card(
                      child: StartPageForm(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(40),
                    child: MaterialButton(
                      onPressed: () => Navigation.openUserPage(context),
                      // Navigation.openPage(context, 'userPageWithoutMenu'),
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
        ),
      );
    } else if (!userLoc.userLocationOk) {
      if (userLoc.locationOn) {
        if (userLoc.distanceFromRadius() != null) {
          messageAboutLocation =
              "Matka hyväksyttävälle etäisyydelle tapahtumapaikasta: " +
                  userLoc.distanceFromRadius().toString() +
                  "m.";
        }
      } else if (!userLoc.positionDataEnabled || !userLoc.locationOn) {
        messageAboutLocation = "Sijainti ei ole käytössä.";
      }
      return WillPopScope(
        //onwill popscope disables the use of the android back button
        onWillPop: () async => false,
        child: Theme(
          data: MasterTheme.mainTheme,
          child: Scaffold(
            body: SafeArea(
              child: ListView(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 100, 30, 5),
                          child: Text(messageAboutLocation,
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
                        onPressed: () => Navigation.openUserPage(context),
                        // Navigation.openPage(context, 'userPageWithoutMenu'),
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
                  MaterialButton(
                    //heinous dev button for bypassing location
                    onPressed: () => Navigation.openUserPage(context),
                    // Navigation.openPage(context, 'userPageWithoutMenu'),
                    color: MasterTheme.bgBoxColour,
                    padding: EdgeInsets.all(2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("DevBtn",
                            style: Theme.of(context).textTheme.body1),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  void checkUserLocation() {
    //follow user position and distance between it and event
    userLoc.updateUserDistanceFromEvent();
    setState(() {});
  }

  void initialiseUserLocationAtStart() async {
    //check for location data at the start
    await userLoc.checkGeolocationPermissionStatus();
    var geolocator = Geolocator();
    var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    // locationUpdateTimer =
    //     Timer.periodic(Duration(seconds: 5), (Timer t) => checkUserLocation());
    StreamSubscription<Position> positionStream = geolocator.getPositionStream(locationOptions).listen(
    (Position position) {
        print(position == null ? 'Unknown' : position.latitude.toString() + ', ' + position.longitude.toString());
        checkUserLocation();
    });

    checkUserLocation();
  }
}
