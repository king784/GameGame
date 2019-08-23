import 'package:flutter/material.dart';
import 'package:flutter_testuu/Themes/MasterTheme.dart';

import '../radialMenu.dart';
import 'package:flutter_testuu/Globals.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  double screenWidth = Global.SCREENWIDTH * .9;
  int watchedGames = 0;
  double paddingVal = 10;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //onwill popscope disables the use of the android back button
      onWillPop: () async => false,
      child: Theme(
        data: MasterTheme.mainTheme,
        child: Scaffold(
          body: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RadialMenu(),
                    Padding(
                      padding: EdgeInsets.all(paddingVal),
                      child: Text(
                        'Käyttäjä',
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.title,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: screenWidth,
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(paddingVal),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Katsotut kotiottelut:',
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context).textTheme.body1,
                                ),
                                Text(
                                  this.watchedGames.toString(),
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context).textTheme.title,
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
            ],
          ),
        ),
      ),
    );
  }

  void getSeenGames() {
    this.watchedGames = 0;
  }
}
