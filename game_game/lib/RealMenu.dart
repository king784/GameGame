import 'package:flutter/material.dart';

//own files
import './pages/home.dart';
import './route_generator.dart';

void main() {
  runApp(
    MaterialApp(
      home: Home(),
      initialRoute: '/home',
      onGenerateRoute: RouteGenerator.generateRoute,
    ),
  );
}
