import 'package:flutter/material.dart';

class MasterTheme {
  static Brightness brightness = Brightness.light;
  
  static Color accentColour = Colors.black;
  static Color awayTeamColour = Colors.black;
  static Color ktpGreen = Color.fromARGB(255, 0, 127, 0);
  static Color bgBoxColour = Color.fromARGB(70, 0, 0, 0);
  static Color opaqueWhite = Color.fromARGB(175, 255, 255, 255);
  static Color primaryColour = Colors.white;
  static Color disabledColor = Colors.grey;
  static Color buttonColor = Colors.white;

  static String regular = 'Quicksand-Regular';
  static String bold = 'Quicksand-Bold';
  static String semibold = 'Quicksand-SemiBold';
  static String medium = 'Quicksand-Medium';
  static String light = 'Quicksand-Light';

  static double headlineSize = 50;
  static double displaySize = 35;
  static double titleSize = 30;
  static double subTitleSize = 22;
  static double subHeadSize = 22;
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
    primaryColor: ktpGreen,
    accentColor: Colors.black,
    disabledColor: disabledColor,
    fontFamily: regular,
    textTheme: TextTheme(
      headline: TextStyle(fontFamily: bold, fontSize: headlineSize),
      title: TextStyle(fontFamily: semibold, fontSize: titleSize, color: primaryColour),
      subtitle: TextStyle(fontFamily: light, fontSize: subTitleSize, color: primaryColour),
      display1: TextStyle(
          fontFamily: medium, fontSize: displaySize, color: ktpGreen),
      display2: TextStyle(
          fontFamily: medium, fontSize: displaySize, color: primaryColour),
      display3: TextStyle(
          fontFamily: bold, fontSize: displaySize, color: accentColour),
      display4: TextStyle(
          fontFamily: bold, fontSize: displaySize, color: awayTeamColour),
      body1: TextStyle(fontFamily: regular, fontSize: body1Size, color: Colors.black),
      body2: TextStyle(fontFamily: regular, fontSize: body2Size, color:primaryColour),
      caption: TextStyle(
          fontFamily: regular, fontSize: body2Size, color: accentColour),
      subhead: TextStyle(
          fontFamily: semibold, fontSize: subHeadSize, color: Colors.black),
      button: TextStyle(
          fontFamily: light, fontSize: btnFontSize, color: buttonColor),
    ),
  );

  static ThemeData playerVotingTheme = new ThemeData(
    brightness: brightness,
    primaryColor: ktpGreen,
    accentColor: Colors.black,
    disabledColor: disabledColor,
    fontFamily: regular,
    textTheme: TextTheme(
      headline: TextStyle(fontFamily: bold, fontSize: headlineSize),
      title: TextStyle(fontFamily: semibold, fontSize: titleSize),
      subtitle: TextStyle(fontFamily: light, fontSize: subTitleSize),
      display1: TextStyle(
          fontFamily: medium, fontSize: 70, color: ktpGreen),
      display2: TextStyle(
          fontFamily: medium, fontSize: 60, color: Colors.black),
      display3: TextStyle(
          fontFamily: bold, fontSize: 50, color: Colors.black),
      display4: TextStyle(
          fontFamily: bold, fontSize: 40, color: ktpGreen),
      body1: TextStyle(fontFamily: regular, fontSize: 25, color: ktpGreen),
      body2: TextStyle(fontFamily: regular, fontSize: 25, color: Colors.black),
      caption: TextStyle(
          fontFamily: regular, fontSize: 20, color: Colors.black),
      subhead: TextStyle(
          fontFamily: semibold, fontSize: 30, color: Colors.black),
      button: TextStyle(
          fontFamily: light, fontSize: btnFontSize, color: ktpGreen),
    ),
  );
}
