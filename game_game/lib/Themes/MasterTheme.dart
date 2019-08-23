import 'package:flutter/material.dart';

class MasterTheme {
  static Brightness brightness = Brightness.dark;
  static Color primaryColour = Colors.white;
  static Color accentColour = Color.fromARGB(255, 0, 127, 0);
  static Color bgBoxColour = Color.fromARGB(175, 65, 68, 68);
  static Color awayTeamColour = Colors.red;

  static String regular = 'Quicksand-Regular';
  static String bold = 'Quicksand-Bold';
  static String semibold = 'Quicksand-SemiBold';
  static String medium = 'Quicksand-Medium';
  static String light = 'Quicksand-Light';

  static double headlineSize = 50;
  static double display1Size = 40;
  static double display2Size = 30;
  static double display3Size = 35;
  static double display4Size = 25;
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
    fontFamily: regular,
    textTheme: TextTheme(
      headline: TextStyle(fontFamily: bold, fontSize: headlineSize),
      title: TextStyle(fontFamily: semibold, fontSize: titleSize),
      subtitle: TextStyle(fontFamily: light, fontSize: subTitleSize),
      display1: TextStyle(fontFamily: medium, fontSize: display1Size, color: accentColour),
      display2: TextStyle(fontFamily: medium, fontSize: display2Size, color: accentColour),
      display3: TextStyle(fontFamily: bold, fontSize: display3Size, color: accentColour),
      display4: TextStyle(fontFamily: bold, fontSize: display4Size, color: accentColour),
      body1: TextStyle(fontFamily: regular, fontSize: body1Size, color: primaryColour),
      body2: TextStyle(fontFamily: regular, fontSize: body2Size),
      caption: TextStyle(fontFamily: regular, fontSize: body2Size, color: accentColour),
      subhead: TextStyle(fontFamily: semibold, fontSize: btnFontSize, color: accentColour),
      button: TextStyle(fontFamily: light, fontSize: btnFontSize, color: primaryColour),
    ),
  );
}
