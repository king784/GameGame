import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'Globals.dart';
import 'QR.dart';
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
  bool firstRun = true;

  @override
  Widget build(BuildContext context) {
    if(firstRun){
      double screenWidth, screenHeight;
      screenWidth = MediaQuery.of(context).size.width;
      screenWidth /= 2.0;
      screenHeight = MediaQuery.of(context).size.height;
      Global.intializeValues(screenWidth, screenHeight);
      firstRun = false;
    }
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
              child: Text('Kirjoita tekstitiedostoon'),
              onPressed: (){
                writeQuestions("Kyssäri 1\nKyssäri 2\nKyssäri 3\nKyssäri 4");
              },
            ),
          ),
          Center(
            child: RaisedButton(
              color: Colors.green[100],
              child: Text('Lue tekstitiedostosta'),
              onPressed: (){
                print(readQuestions());
              },
            ),
          ),
      ],)
    );
  }

  // Move these file management functions to own dart file
  // Find path to file
  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  // Create reference to file location
  Future<File> get localFile async {
    final path = await localPath;
    return File('$path/questions.txt');
  }

  Future<File> writeQuestions(String questions) async {
    final file = await localFile;

    // Write the file
    return file.writeAsString(questions);
  }

  Future<String> readQuestions() async {
    try {
      final file = await localFile;

      // Read the file
      String contents = await file.readAsString();
      print(contents);

      return contents.toString();
    } catch (e) {
      // If encountering an error, return empty string
      return "";
    }
  }
}