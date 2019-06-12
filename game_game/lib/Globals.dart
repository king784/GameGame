// Global variables
import 'package:flutter/material.dart';

class Global{
  static bool GAMELOOP = true;
  static double SCREENWIDTH, SCREENHEIGHT;

    //Trivia global variables
    static String contents = "";
    static String answers = "";

  //Main menu
  static double buttonTextSize = 25;

  static int mainColorValue = 155;
  static Color titleBarColor = new Color.fromRGBO(0, mainColorValue, 0, 1);
  static Color buttonColors = new Color.fromRGBO(0, mainColorValue, 0, 1);

  static void intializeValues(double newScreenWidth, double newScreenHeight) {
    SCREENWIDTH = newScreenWidth;
    SCREENWIDTH /= 2.0;
    SCREENHEIGHT = newScreenHeight;

  }
}