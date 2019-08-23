import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_testuu/Themes/MasterTheme.dart';
import 'package:flutter_testuu/Trivia.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Globals.dart';
import '../Navigation.dart';
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
              Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
                      child: SizedBox(
                        width: Global.SCREENWIDTH * .7,
                        child: RaisedButton(
                          color: MasterTheme.accentColour,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  'Testaa tietosi',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.body1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Icon(
                                  FontAwesomeIcons.hatWizard,
                                  size: 100,
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {
                            Trivia.reFetchQuestion = true;
                            Navigation.openTrivia(context);},
                          // onPressed: () => Navigation.openPage(context, 'trivia'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: SizedBox(
                        width: Global.SCREENWIDTH * .7,
                        child: RaisedButton(
                          color: MasterTheme.accentColour,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  'Päivän paras pelaaja',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.body1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Icon(
                                  FontAwesomeIcons.userNinja,
                                  size: 100,
                                ),
                              ),
                            ],
                          ),
                          onPressed: () => Navigation.openPlayervoting(context),
                          // Navigation.openPage(context, 'playerVoting'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: SizedBox(
                        width: Global.SCREENWIDTH * .7,
                        child: RaisedButton(
                          color: MasterTheme.accentColour,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  'Pelin paras kuva',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.body1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Icon(
                                  FontAwesomeIcons.image,
                                  size: 100,
                                ),
                              ),
                            ],
                          ),
                          onPressed: () => Navigation.openImageVoting(context),
                          // Navigation.openPage(context, 'imageVoting'),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
