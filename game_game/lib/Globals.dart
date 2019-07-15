// Global variables
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Global{
  static bool GAMELOOP = true;
  static double SCREENWIDTH=100, SCREENHEIGHT=100;

    //Trivia global variables
    static String contents = "";
    static String answers = "";

  //Main menu
  static double buttonTextSize = 25;

  static int mainColorValue = 155;
  static Color titleBarColor = new Color.fromRGBO(0, mainColorValue, 0, 1);
  static Color buttonColors = new Color.fromRGBO(0, mainColorValue, 0, 1);

  //Next game date                          
  static DateTime nextGameDate = new DateTime(2019, 07, 26, 00, 00, 00); //Year, month, day, hours, minutes, seconds
  static Color dateTimeColor = new Color.fromRGBO(0, mainColorValue, 0, 1);

  static void intializeValues(double height, double width) {
    SCREENWIDTH = width;
    SCREENHEIGHT = height;
  }
}

class Player{
  int id;
  int currentVotes;
  final String firstName;
  final String lastName;
  final String team;
  int playerNumber;

  Player(this.id, this.currentVotes, this.firstName, this.lastName, this.team, this.playerNumber){}

  Player.fromJson(Map<String, dynamic> json)
  : id = json['ID'],
    firstName = json['firstName'],
    lastName = json['lastName'],
    team = json['team'],
    currentVotes = json['currentVotes'],
    playerNumber = json['playerNumber'];

  Map<String, dynamic> toJson() =>
  {
    'ID': id,
    'firstName': firstName,
    'lastName': lastName,
    'team': team,
    'currentVotes': 0,
    'playerNumber': playerNumber
  };
}

class ImageVotes{
  // ImageVotes instance, we need only 1 that we can access
  ImageVotes.imgVotesPrivate();

  static final ImageVotes _instance = ImageVotes.imgVotesPrivate();

  static ImageVotes get instance{return _instance;}

  int imgIndex;
  List<int> votes = new List<int>();

  ImageVotes.fromJson(Map<String, dynamic> json)
  {
    var votesFromJson = json['votes'];
    List<int> votesList = votesFromJson.cast<int>();
    instance.votes.clear();
    for(int i = 0; i < votesList.length; i++)
    {
      instance.votes.add(votesList[i]);
    }
  }

  Map<String, dynamic> toJson() =>
  {
    'votes': votes,
  };
}