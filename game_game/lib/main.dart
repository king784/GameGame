import 'package:flutter/material.dart';
import 'QR.dart';
import 'ColorGame.dart';
import 'BallGame.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Arial',
      ),
      home: MainMenu(),
    );
  }
}

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Valikko'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
        Center(
          child: RaisedButton(
            color: Colors.green[700],
            child: Text('QR Tunnistus'),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QRReader()),
              );
            },
          ),
        ),
          Center(
            child: RaisedButton(
              color: Colors.green[500],
              child: Text('Pelaa ballopeliä'),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BallMain()),
                );
              },
            ),
          ),
        Center(
          child: RaisedButton(
            color: Colors.green[300],
            child: Text('Pelaa väripeliä'),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ColorMain()),
              );
            },
          ),
        ),
      ],)
    );
  }
}