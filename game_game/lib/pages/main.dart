import 'package:flutter/material.dart';
import 'package:flutter_testuu/NavigationBar/route_generator.dart';
import 'package:flutter_testuu/Themes/MasterTheme.dart';
import 'package:flutter_testuu/pages/gameLiveView.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: MasterTheme.mainTheme,
      title: 'Game Game Messis',
      home: GameLiveView(),
      initialRoute: '/startPage',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
