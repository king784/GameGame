import 'package:flutter/material.dart';
import 'package:flutter_testuu/Themes/MasterTheme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_testuu/Globals.dart';

import '../topBar.dart';

class Ohje extends StatefulWidget {
  @override
  _OhjeState createState() => _OhjeState();
}

class _OhjeState extends State<Ohje> {
  double screenWidth = Global.SCREENWIDTH * .9;
  double paddingVal = 5;
  double paddingBetweenVal = 10;

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
                topBar(context, 'Apuja'),
                Expanded(
                  child: Container(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(paddingVal),
                            child: Text(
                              'Täältä voit saada apuja sovellukseen liittyen.',
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.body1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(paddingBetweenVal),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(paddingVal),
                                  child: Text(
                                    'Omat tilastot',
                                    textAlign: TextAlign.left,
                                    style: Theme.of(context).textTheme.subtitle,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(paddingVal),
                                  child: IconButton(
                                    icon: Icon(FontAwesomeIcons.user),
                                    onPressed: () {},
                                    color: MasterTheme.btnColours[0],
                                    alignment: Alignment.topLeft,
                                    iconSize: 50,
                                  ),
                                ),
                                Text(
                                  'Käyttäjä sivulla näet omat tilastosi.',
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context).textTheme.body1,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(paddingBetweenVal),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(paddingVal),
                                  child: Text(
                                    'Pelin tilanne',
                                    textAlign: TextAlign.left,
                                    style: Theme.of(context).textTheme.subtitle,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(paddingVal),
                                  child: IconButton(
                                    icon: Icon(FontAwesomeIcons.basketballBall),
                                    onPressed: () {},
                                    color: MasterTheme.btnColours[1],
                                    alignment: Alignment.topLeft,
                                    iconSize: 50,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(paddingVal),
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
                            padding: EdgeInsets.all(paddingBetweenVal),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(paddingVal),
                                  child: Text(
                                    'Aktiviteetit',
                                    textAlign: TextAlign.left,
                                    style: Theme.of(context).textTheme.subtitle,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(paddingVal),
                                  child: IconButton(
                                    icon: Icon(FontAwesomeIcons.gamepad),
                                    onPressed: () {},
                                    color: MasterTheme.btnColours[2],
                                    alignment: Alignment.topLeft,
                                    iconSize: 50,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(paddingVal),
                                  child: Text(
                                    'Aktiviteetit sivulla näet listan erilaisisita pienpeleistä ja aktiviteeteista jotka avautuvat pelin aikana. \n\nPelaaja äänestyksessä pääset äänestämään mielestäsi pelin parasta pelaajaa. \n\nKuvakisassa Voit ladata pelistä ottamasi kuvan kaikkien nähtäväksi ja äänestää mielestäsi pelin parasta kuvaa.',
                                    textAlign: TextAlign.left,
                                    style: Theme.of(context).textTheme.body1,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
