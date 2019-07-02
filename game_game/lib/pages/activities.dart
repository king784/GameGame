import 'package:flutter/material.dart';
import 'package:flutter_testuu/Themes/MasterTheme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      child: Theme(
        data: MasterTheme.mainTheme,
        child: Scaffold(
          body: ListView(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Row(
                  children: <Widget>[
                    RadialMenu(),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Aktiviteetit',
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.title,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  width: screenWidth * .8,
                  color: MasterTheme.bgBoxColour,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Pelaaja äänestys',
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.body1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: FloatingActionButton(
                          heroTag: 'toPlayerVoteBtn',
                          child: Icon(FontAwesomeIcons.userNinja),
                          onPressed: () {},
                          backgroundColor: MasterTheme.accentColour,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Pelin paras kuva',
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.body1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: FloatingActionButton(
                          heroTag: 'toImageVoteBtn',
                          child: Icon(FontAwesomeIcons.image),
                          onPressed: () {},
                          backgroundColor: MasterTheme.accentColour,
                        ),
                      ),
                    ],
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
