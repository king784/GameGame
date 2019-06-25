import 'package:flutter/material.dart';
import 'package:flutter_testuu/Themes/MasterTheme.dart';

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
      child: Theme(
        data: MasterTheme.mainTheme,
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
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
