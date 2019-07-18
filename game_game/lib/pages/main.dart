import 'package:flutter/material.dart';
import 'package:flutter_testuu/Themes/MasterTheme.dart';

import '../route_generator.dart';
import 'home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
  
    return MaterialApp(
      theme: MasterTheme.mainTheme,
      title: 'Game Game Messis',
      home: Home(),
      initialRoute: '/startPage',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }

}
