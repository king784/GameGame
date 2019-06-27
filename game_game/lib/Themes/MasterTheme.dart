import 'package:flutter/material.dart';

class MasterTheme {
  static Brightness brightness = Brightness.dark;
  static Color primaryColour = Colors.white;
  static Color accentColour = Color.fromARGB(255, 0, 127, 0);

  static String bestFont = 'Fredericka';

  static double headlineSize = 70;
  static double titleSize = 30;
  static double body1Size = 15;
  static double body2Size = 15;

  static var btnColours=[Colors.orange, Colors.pink, Colors.blue];

  static ThemeData mainTheme = new ThemeData(
    brightness: brightness,
    primaryColor: primaryColour,
    accentColor: accentColour,
    fontFamily: bestFont,
    textTheme: TextTheme(
      headline:
          TextStyle(fontSize: headlineSize, fontWeight: FontWeight.normal),
      title: TextStyle(fontSize: titleSize, fontWeight: FontWeight.bold),
      body1: TextStyle(fontSize: body1Size, fontWeight: FontWeight.normal),
      body2: TextStyle(fontSize: body2Size, fontWeight: FontWeight.bold),
    ),
  );
}
