import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_testuu/Trivia.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'Globals.dart';
import 'QR.dart';
import 'BallGame.dart';
import 'PassTheBall.dart';
import 'mainTrivia.dart';
import 'Trivia.dart';
import 'votePics.dart';

void main() => runApp(MyApp());

class BallMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Arial',
      ),
      home: BallGame(),
    );
  }
}

class BallGame extends StatefulWidget {
  createState() => BallGameState();
}


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

class MainMenu extends StatefulWidget{
  createState() => MainMenuState();
}

class MainMenuState extends State<MainMenu>  {
  bool firstRun = true;

  String kysymysLista = "\nMikä on kuvassa?;\nMontako pelaajaa kentällä voi olla enintään?;\nMikä on Larry Poundsin pelinumero KTP-Basketissa?;\nKuinka monta raitaa on koripallossa?;\nMitkä ovat kansainvälisen koripalloliiton säännöissä koripallokentän mitat?";
  //DateFormat myFormat = new DateFormat("yyyy");
  DateFormat fullFormat = new DateFormat("d/MM/yyyy");
  String nextDate = "";

  bool menuIsActive = true;

  @override
  Widget build(BuildContext context) {

    writeQuestions(kysymysLista);
    readQuestions();

    //if(mounted) menuIsActive = true;

    if(firstRun){
      double screenWidth, screenHeight;
      screenWidth = MediaQuery.of(context).size.width;
      screenWidth /= 2.0;
      screenHeight = MediaQuery.of(context).size.height;
      Global.intializeValues(screenWidth, screenHeight);
      Timer.periodic(Duration(seconds: 1), (Timer t) => nextGameCountdown(Global.nextGameDate));
      firstRun = false;
    }
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Global.titleBarColor,
        title: Text('Valikko'),
      ),

      body: Column( 
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[

         Column(
           children: <Widget>[

             new Text("Mario Maker 2 julkasu: ${fullFormat.format(Global.nextGameDate)}",
             style: new TextStyle(
               fontSize: 20,
                color: Global.dateTimeColor.withGreen(Global.mainColorValue - 10),
                
             ),
             ),

             new Text(nextDate,
              style: new TextStyle(
               fontSize: 20,
               color: Global.dateTimeColor.withGreen(Global.mainColorValue + 50),
             ),
             ),

            ],

            ),
            //Image.asset("images/backGround.jpg",
            //  width: 100,
            //  
            //),

        Center(
          child: RaisedButton(
            color: Global.buttonColors.withGreen((Global.mainColorValue * 1.4).toInt()),
            child: Text('QR Tunnistus',
              style: new TextStyle(
                fontSize: 25
              ),
            ),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QRReader()),
              );
            },
          ),
        ),

          Center(
            child: Center(
            child: RaisedButton(
            color: Global.buttonColors.withGreen((Global.mainColorValue * 1.3).toInt()),
              child: Text('Pelaa ballopeliä',
              style: new TextStyle(
                fontSize: 25
              ),),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BallMain()),
                );
              },
            ),
          ),
          ),

          Center(
            child: RaisedButton(
            color: Global.buttonColors.withGreen((Global.mainColorValue * 1.2).toInt()),
              child: Text('Pass the ball',
              style: new TextStyle(
                fontSize: 25
              ),
              ),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PassTheBallMain()),
                );
              },
            ),
          ),

          Center(
            child: RaisedButton(
            color: Global.buttonColors.withGreen((Global.mainColorValue * 1.1).toInt()),
              child: Text('Trivia',
              style: new TextStyle(
                fontSize: 25
              ),
              ),
              onPressed: (){
               Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Trivia()),
                );
              },
            ),
          ),


          Center(
            child: RaisedButton(
            color: Global.buttonColors.withGreen((Global.mainColorValue * 1).toInt()),
              child: Text('Vote photos',
              style: new TextStyle(
                fontSize: 25
              ),
              ),
              onPressed: (){
                menuIsActive = false;
               Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VotePics()),
                );
              },
            ),
          ),

      ],
      )
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
    //print('$path/questions.txt');
    return File('$path/questions.txt');
  }

  Future<File> writeQuestions(String questions) async {
    final file = await localFile;

    print(questions.length);

    // Write the file
    return file.writeAsString(questions);
  }

  Future<String> readQuestions() async {
    try {
      final file = await localFile;

      // Read the file
      Global.contents = await file.readAsString();
      //print(contents);

      return Global.contents.toString();
    } catch (e) {
      // If encountering an error, return empty string
      return "";
    }
  }

  void nextGameCountdown(DateTime nextGameTime){
    DateTime dateCounter;
    var now = DateTime.now();

    //dateCounter = nextGameTime.difference(now)
    dateCounter = new DateTime(
      nextGameTime.year - now.year,
      nextGameTime.month - now.month,
      nextGameTime.day - now.day,
      nextGameTime.hour - now.hour,
      nextGameTime.minute - now.minute,
      nextGameTime.second - now.second,
    );

    DateFormat newFormat = new DateFormat("dd H:m:s");
    nextDate = "${newFormat.format(dateCounter)}";

    if(menuIsActive){
      setState(() {
      
      });
    }
    //print(myFormat.format(dateCounter));

    //print("Next game: $nextGameTime. Date counter: $dateCounter");
    //print("What? ${nextGameTime.year - now.year}");

    //return "${myFormat.format(dateCounter)}"; //dateCounter;
  }

}