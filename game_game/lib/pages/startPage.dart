import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_testuu/NavigationBar/Navigation.dart';
import 'package:flutter_testuu/NavigationBar/mainMenuAtTop.dart';
import 'package:flutter_testuu/StartPageForm.dart';
import 'package:flutter_testuu/UserAndLocation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter_testuu/Themes/MasterTheme.dart';
import '../Globals.dart';
import 'package:geolocator/geolocator.dart';

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  UserLocation userLoc = new UserLocation();
  Timer locationUpdateTimer;
  String messageAboutLocation = 'Odota, sijaintiasi päivitetään.';

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
            backgroundColor: MasterTheme.ktpGreen,
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(messageAboutLocation,
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context).textTheme.caption),
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
            backgroundColor: MasterTheme.ktpGreen,
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: Global.SCREENHEIGHT,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Text(messageAboutLocation,
                                        textAlign: TextAlign.left,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Card(
                                color: MasterTheme.primaryColour,
                                child: StartPageForm(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: RaisedButton(
                      //go to user statistics
                      onPressed: () {
                        NavBarState.activeIndex = 0;
                        Navigation.openUserPage(context);
                      },
                      // Navigation.openPage(context, 'userPageWithoutMenu'),
                      color: MasterTheme.accentColour,
                      padding: EdgeInsets.all(10),
                      child: Text("Näytä vain omat tietoni",
                      textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.button),
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
            backgroundColor: MasterTheme.ktpGreen,
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
                        onPressed: () {
                          NavBarState.activeIndex = 0;
                          Navigation.openUserPage(context);
                        }, //open up the user page  when no games are ongoing to enable looking at user's own statistics
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
                    onPressed: () {
                      NavBarState.activeIndex = 0;
                      Navigation.openUserPage(context);
                    },
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
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    locationUpdateTimer =
        Timer.periodic(Duration(seconds: 5), (Timer t) => checkUserLocation());
    // StreamSubscription<Position> positionStream = geolocator
    //     .getPositionStream(locationOptions)
    //     .listen((Position position) {
    //   print(position == null
    //       ? 'Unknown'
    //       : position.latitude.toString() +
    //           ', ' +
    //           position.longitude.toString());
    //   checkUserLocation();
    // });

    checkUserLocation();
  }
}
