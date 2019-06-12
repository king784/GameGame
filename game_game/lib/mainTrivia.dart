

//TÄMÄ ON TÄYSIN TURHA KOODI :DDDDD

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import './Trivia.dart';

void main(){
  runApp(
    new MaterialApp(
      home: new triviaApp(),
    )
  );
}

class globals{
  static String contents = "";
  static String answers = "";
}

class triviaApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState(){
    return new QuizState();
  }
}

class QuizState extends State<triviaApp> {

  String kysymysLista = "\nMikä on kuvassa?;\nMontako pelaajaa kentällä voi olla enintään?;\nMikä on Larry Poundsin pelinumero KTP-Basketissa?;\nKuinka monta raitaa on koripallossa?;\nMitkä ovat kansainvälisen koripalloliiton säännöissä koripallokentän mitat?";

  @override
  Widget build(BuildContext context) {

    writeQuestions(kysymysLista);
    readQuestions();

    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Trivia"),
        backgroundColor: Colors.green,
      ),

      body: new Container(
        decoration: new BoxDecoration(
            image: new DecorationImage(
                image: new AssetImage("images/Halli2.jpg"),
                colorFilter: new ColorFilter.mode(
                    Colors.white.withOpacity(0.15), BlendMode.dstATop)
              //fit: BoxFit.cover,
            )
        ),

        margin: const EdgeInsets.all(15.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              "Vastaa kysymyksiin oikein ja voita huikea palkinto :D \n\n",
              textAlign: TextAlign.center,
              style: new TextStyle(
                fontSize: 20.0,

              ),
            ),

            new MaterialButton(
              height: 100.0,
              color: Colors.green,
              onPressed: startQuiz,
              child: new Text(
                "Trivia",
                style: new TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),


            /*
            new MaterialButton(
              height: 100.0,
              color: Colors.green,
              onPressed: (){
                writeQuestions(kysymysLista);
              },
              child: new Text(
                "Kirjoita",
                style: new TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
            new MaterialButton(
              height: 100.0,
              color: Colors.green,
              onPressed: (){
                getContents = globaalii.contents;
                setState(() {
                  readQuestions();
                });
              },
              child: new Text(
                "Lue",
                style: new TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
            new Text(globaalii.contents),
            */

            /*
            new IconButton(
                padding: EdgeInsets.fromLTRB(200, 350.0, 10, 0),
                icon: Icon(
                  Icons.arrow_back,
                  size: 100.0,
                ),
                color: Colors.red,
                tooltip: "Score list",
                onPressed: backBtn
            ),
            */

          ],
        ),
      ),
    );
  }

  //Method to Start Quiz
  void startQuiz() {
    setState(() {
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => new Trivia()));
    });
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
        globals.contents = await file.readAsString();

        return globals.contents.toString();
      }
      catch (e) {
        // If encountering an error, return empty string
        return "";
      }
    }
}

void backBtn() {
  new Container(
    child: new Column(
      //crossAxisAlignment: CrossAxisAlignment.stretch,
      //mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        new Text(
          "Back",
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}