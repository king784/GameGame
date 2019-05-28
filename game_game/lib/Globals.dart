// Global variables
import 'package:flutter/material.dart';

class Global{
  static bool GAMELOOP = true;
  static double SCREENWIDTH, SCREENHEIGHT;

  static void intializeValues(double newScreenWidth, double newScreenHeight) {
    SCREENWIDTH = newScreenWidth;
    SCREENWIDTH /= 2.0;
    SCREENHEIGHT = newScreenHeight;
  }
}