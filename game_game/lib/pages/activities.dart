import 'package:flutter/material.dart';

import '../Globals.dart';
import '../radialMenu.dart';

class Activities extends StatefulWidget {
  @override
  _ActivitiesState createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  double screenWidth = Global.SCREENWIDTH * .9;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //onwill popscope disables the use of the android back button
      onWillPop: () async => false,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(20, 45, 0, 0),
              child: Row(
                children: <Widget>[
                  RadialMenu(),
                  Text(
                    'Aktiviteettejä',
                    style: TextStyle(fontSize: 20.0, color: Colors.green),
                  ),
                ],
              ),
            ),
            Container(
              //text stays inside of screen
              padding: EdgeInsets.all(10.0),
              width: screenWidth,
              child: Column(
                children: <Widget>[
                  Text(
                    'Test your ignorance on facts, play basketball, vote for the best player and the best picture of the game.',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 35.0, color: Colors.green),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
