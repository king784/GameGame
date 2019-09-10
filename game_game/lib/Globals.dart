// Global variables

import 'package:flutter/material.dart';
import 'package:ansicolor/ansicolor.dart';

class Global {
  static bool GAMELOOP = true;
  static double SCREENWIDTH = 100, SCREENHEIGHT = 100;
  static String CURRENTROUTE = "";
  // Trivia timer
  static bool TIMERSTARTED = false;

  //bool for checking if user gave the right gamecode at the start, used for validating disabled routes
  static bool gameCodeCorrect = false;

  // Example:
  // print(Global.pen("ADDING"));
  static AnsiPen greenPen = new AnsiPen()..green();
  static AnsiPen redPen = new AnsiPen()..red();

  //Trivia global variables
  static String contents = "";
  static String answers = "";

  //Main menu
  static double buttonTextSize = 25;

  static int mainColorValue = 155;
  static Color titleBarColor = new Color.fromRGBO(0, mainColorValue, 0, 1);
  static Color buttonColors = new Color.fromRGBO(0, mainColorValue, 0, 1);

  //Next game date
  static DateTime nextGameDate = new DateTime(
      2019, 07, 26, 00, 00, 00); //Year, month, day, hours, minutes, seconds
  static Color dateTimeColor = new Color.fromRGBO(0, mainColorValue, 0, 1);

  static DateTime convertTimestampToDatetime(int msSinceEpoch)
  {
    DateTime convertedTime = DateTime.fromMillisecondsSinceEpoch(msSinceEpoch);
    return convertedTime;

    // how to use:
    // DateTime convertedTime;
    // gamesRef.get().then((DocumentSnapshot ds) {
    //   homeTeam = ds['HomeTeam'];
    //   awayTeam = ds['AwayTeam'];

    //   convertedTime = DateTime.fromMillisecondsSinceEpoch(
    //       ds['VotingStartTime'].millisecondsSinceEpoch);
  }

  static void intializeValues(double height, double width) {
    SCREENWIDTH = width;
    SCREENHEIGHT = height;
  }
}

// Can just check the date
// class VisitedGame
// {
//   DateTime dayOfGame;
//   bool gameHasBeenVisited;

//   VisitedGame(this.dayOfGame, this.gameHasBeenVisited);

//   VisitedGame.fromJson(Map<String, dynamic> json)
//       : dayOfGame = json['dayOfGame'],
//         gameHasBeenVisited = json['gameHasBeenVisited'];

//   Map<String, dynamic> toJson() => {
//         'dayOfGame': dayOfGame,
//         'gameHasBeenVisited': gameHasBeenVisited
//       };

//   static List encodeToJson(List<VisitedGame> list)
//   {
//     List jsonList = List();
//     list.map((item) => jsonList.add(item.toJson())).toList();
//     return jsonList;
//   }
// }

class Player {
  int id;
  int currentVotes;
  final String firstName;
  final String lastName;
  final String team;
  int playerNumber;

  Player(this.id, this.currentVotes, this.firstName, this.lastName, this.team,
      this.playerNumber);

  Player.fromJson(Map<String, dynamic> json)
      : id = json['ID'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        team = json['team'],
        currentVotes = json['currentVotes'],
        playerNumber = json['playerNumber'];

  Map<String, dynamic> toJson() => {
        'ID': id,
        'firstName': firstName,
        'lastName': lastName,
        'team': team,
        'currentVotes': 0,
        'playerNumber': playerNumber
      };
}

class ImageVotes {
  // ImageVotes instance, we need only 1 that we can access
  ImageVotes.imgVotesPrivate();

  static final ImageVotes _instance = ImageVotes.imgVotesPrivate();

  static ImageVotes get instance {
    return _instance;
  }

  int imgIndex;
  List<int> votes = new List<int>();

  ImageVotes.fromJson(Map<String, dynamic> json) {
    var votesFromJson = json['votes'];
    List<int> votesList = votesFromJson.cast<int>();
    instance.votes.clear();
    for (int i = 0; i < votesList.length; i++) {
      instance.votes.add(votesList[i]);
    }
  }

  Map<String, dynamic> toJson() => {
        'votes': votes,
      };
}

class Question {
  String question;
  List<String> choices = new List<String>();
  int correct;
  String imagePath;
  var questionTime;

  Question(String newQuestion, List<String> newChoices, int newCorrect,
      String newImagePath, DateTime newQuestionTime) {
    this.question = newQuestion;
    this.choices = newChoices;
    this.correct = newCorrect;
    this.imagePath = newImagePath;
    this.questionTime = newQuestionTime;
  }

  Question.fromJson(Map<String, dynamic> json) {
    this.question = json['question'];
    this.correct = json['correct'];
    this.imagePath = json['imagePath'];
    var choicesFromJson = json['choices'];

    List<String> choicesList = choicesFromJson.cast<String>();
    for (int i = 0; i < choicesList.length; i++) {
      this.choices.add(choicesList[i]);
    }

    this.questionTime = json['questionTime'];
    this.questionTime = DateTime.fromMillisecondsSinceEpoch(
        this.questionTime.millisecondsSinceEpoch);
    // DocumentReference gamesRef = await Firestore.instance
    //     .collection('games')
    //     .document('iSFhdMRlPSQWh3879pXL');
    // DateTime convertedTime;
    // gamesRef.get().then((DocumentSnapshot ds) {
    //   homeTeam = ds['HomeTeam'];
    //   awayTeam = ds['AwayTeam'];

    //   convertedTime = DateTime.fromMillisecondsSinceEpoch(
    //       ds['VotingStartTime'].millisecondsSinceEpoch);
  }

  Map<String, dynamic> toJson() => {
        'choices': choices,
        'correct': correct,
        'imagePath': imagePath,
        'question': question,
        'questionTime': questionTime
      };
}
