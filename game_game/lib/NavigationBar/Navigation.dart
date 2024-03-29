import 'package:flutter/material.dart';

class Navigation {
  // static void openPage(BuildContext context, String pageName) {
  //   Navigator.of(context).pushNamed('/' + pageName, arguments: pageName);
  // }

  static void openGameLiveViewPage(BuildContext context) {
    // Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
    //Navigator.of(context).popUntil((route) => route.isFirst);
    // Navigator.pop(context);
    //Navigator.of(context).pushNamed('/home', arguments: 'home');
    Navigator.of(context).pushReplacementNamed('/gameLiveView', arguments: 'gameLiveView');
  }

  static void openHelpPage(BuildContext context) {
    // Navigator.pop(context);
    //Navigator.of(context).pushNamed('/help', arguments: 'help');
    Navigator.of(context).pushReplacementNamed('/help', arguments: 'help');
  }

  static void openActivitiesPage(BuildContext context) {
    //Navigator.pop(context);
    //Navigator.of(context).pushNamed('/activities', arguments: 'activities');
    Navigator.of(context).pushReplacementNamed('/activities', arguments: 'activities');
  }

  static void openUserPage(BuildContext context) {
    // Navigator.pop(context);
    //Navigator.of(context).pushNamed('/userPage', arguments: 'userPage');
    Navigator.of(context).pushReplacementNamed('/userPage', arguments: 'userPage');
  }

  static void openStartPage(BuildContext context) {
    // Navigator.pop(context);
    //Navigator.of(context).pushNamed('/startPage', arguments: 'startPage');
    Navigator.of(context).pushReplacementNamed('/startPage', arguments: 'startPage');
  }

  static void openImageVoting(BuildContext context) {
    // Navigator.pop(context);
    //Navigator.of(context).pushNamed('/imageVoting', arguments: 'imageVoting');
    Navigator.of(context).pushReplacementNamed('/imageVoting', arguments: 'imageVoting');
  }

  static void openPlayervoting(BuildContext context) {
    // Navigator.pop(context);
    //Navigator.of(context).pushNamed('/playerVoting', arguments: 'playerVoting');
    Navigator.of(context).pushReplacementNamed('/playerVoting', arguments: 'playerVoting');
  }

  static void openTrivia(BuildContext context) {
    // Navigator.pop(context);
    //Navigator.of(context).pushNamed('/trivia', arguments: 'trivia');
    Navigator.of(context).pushReplacementNamed('/trivia', arguments: 'trivia');
  }

  static void openSummary(BuildContext context) {
    // Navigator.pop(context);
    //Navigator.of(context).pushNamed('/summary', arguments: 'summary');
    Navigator.of(context).pushReplacementNamed('/summary', arguments: 'summary');
  }
  
  static void openAddQuestions(BuildContext context) {
    // Navigator.pop(context);
    // Navigator.of(context).pushNamed('/trivia', arguments: 'trivia');
    Navigator.of(context).pushReplacementNamed('/addQuestions', arguments: 'addQuestions');
  }

  static void openUserAuthentication(BuildContext context) {
    // Navigator.pop(context);
    // Navigator.of(context).pushNamed('/trivia', arguments: 'trivia');
    Navigator.of(context).pushReplacementNamed('/userAuthentication', arguments: 'userAuthentication');
  }
}
