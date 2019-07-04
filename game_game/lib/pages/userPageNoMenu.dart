import 'package:flutter/material.dart';
import 'package:flutter_testuu/Navigation.dart';

import 'package:flutter_testuu/Themes/MasterTheme.dart';
import 'package:flutter_testuu/Globals.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserPageWithoutMenu extends StatefulWidget {
  @override
  _UserPageWithoutMenuState createState() => _UserPageWithoutMenuState();
}

class _UserPageWithoutMenuState extends State<UserPageWithoutMenu> {
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
                    Padding(
                      padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                      child: FloatingActionButton(
                          heroTag: 'backBtn1',
                          child: Icon(
                            FontAwesomeIcons.arrowLeft,
                            color: MasterTheme.accentColour,
                            size: 40,
                          ),
                          backgroundColor: Colors.transparent,
                          onPressed: () => Navigation.openStartPage(context),
                          elevation: 0),
                    ),
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
              Padding(
                padding: EdgeInsets.all(10),
                child: Card(
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

  void getSeenGames() {
    this.watchedGames = 0;
  }
}
