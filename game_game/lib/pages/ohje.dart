import 'package:flutter/material.dart';

import '../radialMenu.dart';
import 'package:flutter_testuu/Globals.dart';

class Ohje extends StatefulWidget {
  @override
  _OhjeState createState() => _OhjeState();
}

class _OhjeState extends State<Ohje> {
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
                    'Apuva!',
                    style: TextStyle(fontSize: 20.0, color: Colors.green),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              width: screenWidth,
              child: Column(
                children: <Widget>[
                  Text(
                    'Here you might get help for using this app!',
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
