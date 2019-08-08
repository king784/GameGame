import 'package:flutter/material.dart';
import 'package:flutter_testuu/Trivia.dart';
import 'package:flutter_testuu/Voting.dart';
import 'package:flutter_testuu/pages/PictureCompetition.dart';
//import 'package:routing_prep/main.dart';

import 'package:flutter_testuu/pages/activities.dart';
import 'package:flutter_testuu/pages/ohje.dart';
import 'package:flutter_testuu/pages/startPage.dart';
import 'package:flutter_testuu/pages/userPageNoMenu.dart';
import 'package:flutter_testuu/pictures.dart';
import './pages/home.dart';
import './pages/userPage.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/startPage':
        return MaterialPageRoute(builder: (_) => Start());

      case '/home':
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => Home(),
          );
        }
        return _errorRoute();

      case '/activities':
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => Activities(),
          );
        }
        return _errorRoute();
      case '/help':
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => Ohje(),
          );
        }
        return _errorRoute();

      case '/userPage':
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => UserPage(),
          );
        }
        return _errorRoute();

        case '/userPageWithoutMenu':
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => UserPageWithoutMenu(),
          );
        }
        return _errorRoute();

        case '/imageVoting':
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => PictureCompetition(),
          );
        }
        return _errorRoute();

        case '/playerVoting':
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => PlayerVoting(),
          );
        }
        return _errorRoute();

        case '/trivia':
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => Trivia(),
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
          child: Text('Error'),
        ),
      );
    });
  }
}
