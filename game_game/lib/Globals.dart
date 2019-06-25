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
  static DateTime nextGameDate = new DateTime(2019, 06, 28, 00, 00, 00); //Year, month, day, hours, minutes, seconds
  static Color dateTimeColor = new Color.fromRGBO(0, mainColorValue, 0, 1);

  static void intializeValues(double height, double width) {
    SCREENWIDTH = width;
    SCREENHEIGHT = height;
  }
}

class Player{
  int currentVotes;
  final String firstName;
  final String lastName;
  final String team;

  Player(this.currentVotes, this.firstName, this.lastName, this.team){}

  Player.fromJson(Map<String, dynamic> json)
  : firstName = json['firstName'],
    lastName = json['lastName'],
    team = json['team'],
    currentVotes = json['currentVotes'];

  Map<String, dynamic> toJson() =>
  {
    'firstName': firstName,
    'lastName': lastName,
    'team': team,
    'currentVotes': 0,
  };
}