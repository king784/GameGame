import 'package:flutter/material.dart';
import 'package:flutter_testuu/Admin/AddQuestions.dart';
import 'package:flutter_testuu/Trivia.dart';
import 'package:flutter_testuu/PlayerVoting.dart';
import 'package:flutter_testuu/pages/gameLiveView.dart';
import 'package:flutter_testuu/pages/PictureCompetition.dart';

import 'package:flutter_testuu/pages/activities.dart';
import 'package:flutter_testuu/pages/ohje.dart';
import 'package:flutter_testuu/pages/startPage.dart';
import 'package:flutter_testuu/pages/userPage.dart';

import '../Globals.dart';
import '../UserAuthentication.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/startPage':
        Global.CURRENTROUTE = "/startPage";
        return MaterialPageRoute(builder: (_) => Start());

      case '/gameLiveView':
        Global.CURRENTROUTE = "/gameLiveView";
        if (args is String) {
          return MaterialPageRoute(
            settings: RouteSettings(
                isInitialRoute: true), //stops the transition animation
            builder: (_) => GameLiveView(),
          );
        }
        return _errorRoute();

      case '/activities':
        Global.CURRENTROUTE = "/activities";
        if (args is String) {
          return MaterialPageRoute(
            settings: RouteSettings(isInitialRoute: true),
            builder: (_) => Activities(),
          );
        }
        return _errorRoute();

      case '/help':
        Global.CURRENTROUTE = "/help";
        if (args is String) {
          return MaterialPageRoute(
            settings: RouteSettings(isInitialRoute: true),
            builder: (_) => Ohje(),
          );
        }
        return _errorRoute();

      case '/userPage':
        Global.CURRENTROUTE = "/userPage";
        if (args is String) {
          return MaterialPageRoute(
            settings: RouteSettings(isInitialRoute: true),
            builder: (_) => UserPage(),
          );
        }
        return _errorRoute();

      case '/imageVoting':
        Global.CURRENTROUTE = "/imageVoting";
        if (args is String) {
          return MaterialPageRoute(
            settings: RouteSettings(isInitialRoute: true),
            builder: (_) => PictureCompetition(),
          );
        }
        return _errorRoute();

      case '/playerVoting':
        Global.CURRENTROUTE = "/playerVoting";
        if (args is String) {
          return MaterialPageRoute(
            settings: RouteSettings(isInitialRoute: true),
            builder: (_) => PlayerVoting(),
          );
        }
        return _errorRoute();

      case '/trivia':
        Global.CURRENTROUTE = "/trivia";
        if (args is String) {
          return MaterialPageRoute(
            settings: RouteSettings(isInitialRoute: true),
            builder: (_) => Trivia(),
          );
        }
        return _errorRoute();

      case '/addQuestions':
        Global.CURRENTROUTE = "/addQuestions";
        if (args is String) {
          return MaterialPageRoute(
            settings: RouteSettings(isInitialRoute: true),
            builder: (_) => AddQuestionForm(),
          );
        }
        return _errorRoute();

      case '/userAuthentication':
        Global.CURRENTROUTE = "/userAuthentication";
        return MaterialPageRoute(builder: (_) => UserAuthentication());
        

      default:
        return _errorRoute();
    }
  }
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
        settings: RouteSettings(isInitialRoute: true),
        builder: (_) {
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
