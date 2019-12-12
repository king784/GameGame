import 'package:flutter/material.dart';
import 'package:flutter_testuu/NavigationBar/Navigation.dart';
import 'package:flutter_testuu/NavigationBar/mainMenuAtTop.dart';
import 'package:flutter_testuu/NavigationBar/topBar.dart';
import 'package:flutter_testuu/Themes/MasterTheme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_testuu/Globals.dart';

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
                                    style: Theme.of(context).textTheme.subhead,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(paddingVal),
                                  child: IconButton(
                                    icon: Icon(FontAwesomeIcons.user),
                                    onPressed: () {
                                      NavBarState.setActiveIndex(0);
                                      Navigation.openUserPage(context);
                                      },
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
                          // Padding(
                          //   padding: EdgeInsets.all(paddingBetweenVal),
                          //   child: Column(
                          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: <Widget>[
                          //       Padding(
                          //         padding: EdgeInsets.all(paddingVal),
                          //         child: Text(
                          //           'Pelin tilanne',
                          //           textAlign: TextAlign.left,
                          //           style: Theme.of(context).textTheme.subtitle,
                          //         ),
                          //       ),
                          //       Padding(
                          //         padding: EdgeInsets.all(paddingVal),
                          //         child: IconButton(
                          //           icon: Icon(FontAwesomeIcons.basketballBall),
                          //           onPressed: ()=>Navigation.openGameLiveViewPage(context),
                          //           color: MasterTheme.btnColours[1],
                          //           alignment: Alignment.topLeft,
                          //           iconSize: 50,
                          //         ),
                          //       ),
                          //       Padding(
                          //         padding: EdgeInsets.all(paddingVal),
                          //         child: Text(
                          //           'Pelin tilanne sivulla näet pelin pistetilanteen ja pelatun peliajan.',
                          //           textAlign: TextAlign.left,
                          //           style: Theme.of(context).textTheme.body1,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
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
                                    style: Theme.of(context).textTheme.subhead,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(paddingVal),
                                  child: IconButton(
                                    icon: Icon(FontAwesomeIcons.gamepad),
                                    onPressed: () {
                                      NavBarState.setActiveIndex(1);
                                      Navigation.openActivitiesPage(context);
                                      },
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
