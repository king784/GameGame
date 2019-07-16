import 'package:flutter/material.dart';
import 'package:flutter_testuu/StartPageForm.dart';
import 'package:flutter_testuu/UserAndLocation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter_testuu/Themes/MasterTheme.dart';
import '../Globals.dart';
import '../Navigation.dart';

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
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

    //check for location data
    UserLocation().checkGeolocationPermissionStatus();

//follow user position and distance between it and event
    UserLocation().updateUserDistanceFromEvent();

//if location data is enabled and userlocation is close enough to event location
    if (UserLocation.positionDataEnabled && UserLocation.userLocationOk) {
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
                Card(
                  child: Column(
                    children: <Widget>[
                      Text(UserLocation.userPos.toString()),
                      Text(UserLocation().eventAddress[0].position.toString()),
                    ],
                  ),
                )
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
}
