import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_testuu/Themes/MasterTheme.dart';
import 'package:flutter_testuu/pages/pictureCard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Navigation.dart';

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
          body: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: Container(
                    color: MasterTheme.accentColour,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(2, 10, 10, 10),
                          child: FloatingActionButton(
                              heroTag: 'backBtn2',
                              child: Icon(
                                FontAwesomeIcons.arrowLeft,
                                color: MasterTheme.primaryColour,
                                size: 40,
                              ),
                              backgroundColor: Colors.transparent,
                              onPressed: () => Navigation.openGames(context),
                              elevation: 0),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Kuvaäänestys',
                              textAlign: TextAlign.right,
                              style: Theme.of(context).textTheme.title,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: SingleChildScrollView(
                    child: PictureCardList(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
