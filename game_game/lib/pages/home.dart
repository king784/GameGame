import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_testuu/Themes/MasterTheme.dart';

import '../Globals.dart';
import '../radialMenu.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  int homePoints, opponentPoints;


  @override
  Widget build(BuildContext context) {
    Global.intializeValues(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.width);
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
                          'Tilanne',
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.title,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '0',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '-',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '0',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(50, 50, 0, 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Peliä pelattu:',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.body1,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '00:00:00',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline,
                      ),
                    ),
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
