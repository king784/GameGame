import 'package:flutter/material.dart';

class Navigation {
  static void openMainPage(BuildContext context) {
    Navigator.of(context).pushNamed('/home', arguments: 'home');
  }

  static void openHelp(BuildContext context) {
    Navigator.of(context).pushNamed('/help', arguments: 'help');
  }

  static void openGames(BuildContext context) {
    Navigator.of(context).pushNamed('/activities', arguments: 'activities');
  }

  static void openUserPage(BuildContext context) {
    Navigator.of(context).pushNamed('/userPage', arguments: 'userPage');
  }

  static void openUserPageWithoutMenu(BuildContext context) {
    Navigator.of(context).pushNamed('/userPageWithoutMenu', arguments: 'userPageWithoutMenu');
  }

  static void openStartPage(BuildContext context) {
    Navigator.of(context).pushNamed('/startPage', arguments: 'startPage');
  }
}
