import 'package:flutter/material.dart';

import '../Globals.dart';
import '../radialMenu.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    Global.intializeValues(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.width);
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
                    'Pelin tiedot',
                    style: TextStyle(fontSize: 20.0, color: Colors.green),
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'data',
                    style: TextStyle(fontSize: 35.0, color: Colors.green),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
