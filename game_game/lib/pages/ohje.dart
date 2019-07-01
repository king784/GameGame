import 'package:flutter/material.dart';
import 'package:flutter_testuu/Themes/MasterTheme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../radialMenu.dart';
import 'package:flutter_testuu/Globals.dart';

class Ohje extends StatefulWidget {
  @override
  _OhjeState createState() => _OhjeState();
}

class _OhjeState extends State<Ohje> {
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
                          'Apuja',
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.title,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Täältä voit saada apuja sovellukseen liittyen.',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.body1,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
                child: Text(
                  'Käyttäjä sivu',
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.subtitle,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                child: IconButton(
                  icon: Icon(FontAwesomeIcons.user),
                  onPressed: () {},
                  color: MasterTheme.btnColours[0],
                  alignment: Alignment.topLeft,
                  iconSize: 50,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 10, 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Käyttäjä sivulla näet omat tilastosi.',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.body1,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
                child: Text(
                  'Pelin tilanne',
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.subtitle,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                child: IconButton(
                  icon: Icon(FontAwesomeIcons.basketballBall),
                  onPressed: () {},
                  color: MasterTheme.btnColours[1],
                  alignment: Alignment.topLeft,
                  iconSize: 50,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 10, 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Pelin tilanne sivulla näet pelin pistetilanteen ja pelatun peliajan.',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.body1,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
                child: Text(
                  'Aktiviteetit',
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.subtitle,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                child: IconButton(
                  icon: Icon(FontAwesomeIcons.gamepad),
                  onPressed: () {},
                  color: MasterTheme.btnColours[2],
                  alignment: Alignment.topLeft,
                  iconSize: 50,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 10, 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Aktiviteetit sivulla näet listan erilaisisita pienpeleistä ja aktiviteeteista jotka avautuvat pelin aikana. \n\nPelaaja äänestyksessä pääset äänestämään mielestäsi pelin parasta pelaajaa. \n\nKuvakisassa Voit ladata pelistä ottamasi kuvan kaikkien nähtäväksi ja äänestää mielestäsi pelin parasta kuvaa.',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.body1,
                      ),
                    )
                  ],
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.all(10),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
