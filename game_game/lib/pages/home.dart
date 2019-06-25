import 'package:flutter/material.dart';

import '../radialMenu.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(20,0,0,0),
            child: Row(
              children: <Widget>[
                RadialMenu(),
                Text(
                  'Pelin tiedot',
                  style: TextStyle(fontSize: 20.0, color: Colors.green),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'data',
                  style: TextStyle(fontSize: 35.0, color: Colors.green),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
