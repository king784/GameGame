import 'dart:async';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_testuu/Assets/visualAssets.dart';
import 'package:flutter_testuu/NavigationBar/Navigation.dart';
import 'package:flutter_testuu/NavigationBar/mainMenuAtTop.dart';
import 'package:flutter_testuu/StartPageForm.dart';
import 'package:flutter_testuu/UserAndLocation.dart';

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

    if (userLoc.loadingLocation) {
      messageAboutLocation = "Sijaintiasi päivitetään.";
    } else if (userLoc.userLocationOk) {
      messageAboutLocation = "Sijainti on kunnossa.";
    } else if (!userLoc.userLocationOk && userLoc.locationOn) {
      if (userLoc.distanceFromRadius() != null) {
        messageAboutLocation =
            "Matka hyväksyttävälle etäisyydelle tapahtumapaikasta: " +
                userLoc.distanceFromRadius().toString() +
                "m.";
      }
    } else if (!userLoc.positionDataEnabled || !userLoc.locationOn) {
      messageAboutLocation =
          "Sijainti ei ole käytössä.\nKäy asetuksista antamassa lupa sijainnille ja käynnistä sitten sovellus uudestaan.";
    }
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: Text(messageAboutLocation,                                
                                style: Theme.of(context).textTheme.caption),
                          ),
                          userLoc.userLocationOk
                              ? Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Card(
                                    color: MasterTheme.primaryColour,
                                    child: StartPageForm(),
                                  ),
                                )
                              : SizedBox.shrink()
                        ],
                      ),
                    ),
                  ),
                ),
                !userLoc.loadingLocation? NiceButton('Näytä vain omat tiedot', context,
                    customColour: MasterTheme.accentColour, function: () {
                  NavBarState.setActiveIndex(0);
                  Navigation.openUserPage(context);
                }):SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
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
