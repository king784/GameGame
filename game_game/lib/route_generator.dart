import 'package:flutter/material.dart';
import 'package:flutter_testuu/Trivia.dart';
import 'package:flutter_testuu/Voting.dart';
import 'Globals.dart';
import 'package:flutter_testuu/pages/PictureCompetition.dart';
//import 'package:routing_prep/main.dart';

import 'package:flutter_testuu/pages/activities.dart';
import 'package:flutter_testuu/pages/ohje.dart';
import 'package:flutter_testuu/pages/startPage.dart';
import 'package:flutter_testuu/pages/userPageNoMenu.dart';
import './pages/home.dart';
import './pages/userPage.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/startPage':
        Global.CURRENTROUTE = "/startPage";
        return MaterialPageRoute(builder: (_) => Start());

      case '/home':
        Global.CURRENTROUTE = "/home";
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => Home(),
          );
        }
        return _errorRoute();

      case '/activities':
        Global.CURRENTROUTE = "/activities";
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => Activities(),
          );
        }
        return _errorRoute();

      case '/help':
        Global.CURRENTROUTE = "/help";
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => Ohje(),
          );
        }
        return _errorRoute();

      case '/userPage':
        Global.CURRENTROUTE = "/userPage";
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => UserPage(),
          );
        }
        return _errorRoute();

        case '/userPageWithoutMenu':
        Global.CURRENTROUTE = "/userPageWithoutMenu";
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => UserPageWithoutMenu(),
          );
        }
        return _errorRoute();

        case '/imageVoting':
        Global.CURRENTROUTE = "/imageVoting";
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => PictureCompetition(),
          );
        }
        return _errorRoute();

        case '/playerVoting':
        Global.CURRENTROUTE = "/playerVoting";
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => PlayerVoting(),
          );
        }
        return _errorRoute();

        case '/trivia':
        Global.CURRENTROUTE = "/trivia";
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => Trivia(),
          );
        }
        return _errorRoute();

         case '/summary':
        Global.CURRENTROUTE = "/summary";
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => Summary(),
          );
        }
        return _errorRoute();

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Error\n:)'),
        ),
      );
    });
  }
}
