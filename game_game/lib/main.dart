import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_testuu/Themes/MasterTheme.dart';
import 'package:flutter_testuu/pages/gameLiveView.dart';
import 'NavigationBar/route_generator.dart';

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
