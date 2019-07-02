import 'package:flutter/material.dart';
import 'package:flutter_testuu/Themes/MasterTheme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../radialMenu.dart';
import 'package:flutter_testuu/Globals.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  double screenWidth = Global.SCREENWIDTH * .9;
  int watchedGames = 0;

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
                          'Käyttäjä',
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
                  width: screenWidth * .8,
                  color: MasterTheme.bgBoxColour,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Katsotut kotiottelut:',
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.body1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          this.watchedGames.toString(),
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.title,
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

  void getSeenGames(){
    this.watchedGames = 0;
  }
}
