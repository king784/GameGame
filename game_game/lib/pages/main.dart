import 'package:flutter/material.dart';

import '../route_generator.dart';
import 'home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Game Messis',
      home: Home(),
      initialRoute: '/home',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
