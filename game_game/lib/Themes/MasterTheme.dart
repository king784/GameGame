import 'package:flutter/material.dart';

class MasterTheme {
  static Brightness brightness = Brightness.dark;
  static Color primaryColour = Colors.white;
  static Color accentColour = Color.fromARGB(255, 0, 127, 0);
  static Color bgBoxColour = Color.fromARGB(150, 65, 68, 68);

  static String bestFont = 'Fredericka';

  static double headlineSize = 70;
  static double display1Size = 100;
  static double titleSize = 30;
  static double subTitleSize = 22;
  static double subHeadSize = 19;
  static double body1Size = 15;
  static double body2Size = 15;
  static double btnFontSize = 20;

  static var btnColours = [
    Color.fromARGB(255, 0, 127, 0),
    Colors.orange,
    Colors.pink,
    Colors.blue
  ];

  static ThemeData mainTheme = new ThemeData(
    brightness: brightness,
    primaryColor: primaryColour,
    accentColor: accentColour,
    fontFamily: bestFont,
    textTheme: TextTheme(
      headline:
          TextStyle(fontSize: headlineSize, fontWeight: FontWeight.normal),
      title: TextStyle(fontSize: titleSize, fontWeight: FontWeight.bold),
      subtitle:
          TextStyle(fontSize: subTitleSize, fontWeight: FontWeight.normal),
      display1: TextStyle(fontSize: display1Size, fontWeight: FontWeight.bold, color: primaryColour),
      body1: TextStyle(fontSize: body1Size, fontWeight: FontWeight.normal),
      body2: TextStyle(fontSize: body2Size, fontWeight: FontWeight.bold),
      subhead: TextStyle(
          fontSize: btnFontSize,
          fontWeight: FontWeight.normal,
          color: accentColour),
      button: TextStyle(
          fontSize: btnFontSize,
          fontWeight: FontWeight.normal,
          color: bgBoxColour),
    ),
  );
}
