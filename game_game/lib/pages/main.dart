import 'package:flutter/material.dart';
import 'package:flutter_testuu/NavigationBar/route_generator.dart';
import 'package:flutter_testuu/Themes/MasterTheme.dart';
import 'package:flutter_testuu/pages/ohje.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: MasterTheme.mainTheme,
      title: 'Game Game Messis',
      home: Ohje(),
      initialRoute: '/startPage',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
