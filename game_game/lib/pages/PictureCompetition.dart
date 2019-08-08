import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_testuu/Themes/MasterTheme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Globals.dart';
import '../Navigation.dart';
import '../radialMenu.dart';

class PictureCompetition extends StatefulWidget {
  @override
  _PictureCompetitionState createState() => _PictureCompetitionState();
}

class _PictureCompetitionState extends State<PictureCompetition> {
  @override
  void initState() {
    super.initState();
  }

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
                                heroTag: 'backBtn2',
                                child: Icon(
                                  FontAwesomeIcons.arrowLeft,
                                  color: MasterTheme.accentColour,
                                  size: 40,
                                ),
                                backgroundColor: Colors.transparent,
                                onPressed: () => Navigation.openGames(context),
                                elevation: 0),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                'Kuva äänestys',
                                textAlign: TextAlign.right,
                                style: Theme.of(context).textTheme.title,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

            ],
          ),
        ),
      ),
    );
  }
}
