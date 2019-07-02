import 'package:flutter/material.dart';
//import 'package:routing_prep/main.dart';

import 'package:flutter_testuu/pages/activities.dart';
import 'package:flutter_testuu/pages/ohje.dart';
import './pages/home.dart';
import './pages/userPage.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(builder: (_) => Home());

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
