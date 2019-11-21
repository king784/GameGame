import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_testuu/NavigationBar/topBar.dart';
import 'package:flutter_testuu/Themes/MasterTheme.dart';

import '../Globals.dart';

class GameLiveView extends StatefulWidget {
  @override
  _GameLiveViewState createState() => _GameLiveViewState();
}

class _GameLiveViewState extends State<GameLiveView> {
  int homePoints = 0, opponentPoints = 0;
  String homeLogo, opponentLogo, homeTeamName, opponentTeamName;
  double _logoSize = 100;

  @override
  void initState() {
    super.initState();
    getTeamLogosAndNames();
    _logoSize = Global.SCREENWIDTH * .35;
  }

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
                topBar(context, 'Tilanne'),
                Expanded(
                  child: Container(
                    child: SingleChildScrollView(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          //gametime
                          padding: EdgeInsets.all(20),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: MasterTheme.ktpGreen,
                                    width: 2,
                                    style: BorderStyle.solid)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                  'Peliaika:',
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context).textTheme.body1,
                                ),
                                Text(
                                  '00:00:00',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.title,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          //current game score
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      'Koti',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.body1,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.body1,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Vieras',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.body1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      '0',
                                      textAlign: TextAlign.center,
                                      style:
                                          Theme.of(context).textTheme.headline,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '-',
                                      textAlign: TextAlign.center,
                                      style:
                                          Theme.of(context).textTheme.headline,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '0',
                                      textAlign: TextAlign.center,
                                      style:
                                          Theme.of(context).textTheme.headline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Image.network(
                                //home team logo
                                homeLogo,
                                width: _logoSize,
                                height: _logoSize,
                              ),
                              Container(
                                  //middle graphic with line and vs text
                                  width: 30,
                                  height: _logoSize + 50,
                                  //color: Colors.white,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/middleLine.png"),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'vs',
                                      style: Theme.of(context).textTheme.body1,
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                              Image.network(
                                opponentLogo, //away team logo
                                width: _logoSize,
                                height: _logoSize,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getGameInfo() {}

  void getTeamLogosAndNames() {
    homeLogo =
        'https://upload.wikimedia.org/wikipedia/fi/thumb/f/f5/KTP-Basket_logo.svg/1280px-KTP-Basket_logo.svg.png';
    opponentLogo =
        'https://upload.wikimedia.org/wikipedia/fi/thumb/9/9b/Kauhajoen_Karhu_Basket_logo.svg/866px-Kauhajoen_Karhu_Basket_logo.svg.png';
    homeTeamName = 'KTP';
    opponentTeamName = 'Kauhajoen Karhut';
  }
}
