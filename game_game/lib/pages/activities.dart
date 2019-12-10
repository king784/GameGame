import 'package:flutter/material.dart';
import 'package:flutter_testuu/Assets/visualAssets.dart';
import 'package:flutter_testuu/NavigationBar/Navigation.dart';
import 'package:flutter_testuu/NavigationBar/topBar.dart';
import 'package:flutter_testuu/Themes/MasterTheme.dart';
import 'package:flutter_testuu/Trivia.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Globals.dart';

class Activities extends StatefulWidget {
  @override
  _ActivitiesState createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  double buttonWidth = Global.SCREENWIDTH * .9;
  double iconSize = 50;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //onwill popscope disables the use of the android back button
      onWillPop: () async => false,
      child: Theme(
        data: MasterTheme.mainTheme,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: <Widget>[
                topBar(context, 'Aktiviteetit'),
                Expanded(
                  child: Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          NiceButtonWithIcon('Testaa tietosi', context,
                              FontAwesomeIcons.hatWizard, function: () {
                            Trivia.reFetchQuestion = true;
                            Navigation.openTrivia(context);
                          }),
                          NiceButtonWithIcon('Päivän paras pelaaja', context,
                              FontAwesomeIcons.star, function: () {
                            Navigation.openPlayervoting(context);
                          }),
                          NiceButtonWithIcon('Pelin paras kuva', context,
                              FontAwesomeIcons.image, function: () {
                            Navigation.openImageVoting(context);
                          }),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
