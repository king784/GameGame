import 'package:flutter/material.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart' show radians;

//import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RadialMenu extends StatefulWidget {
  createState() => _RadialMenuState();
}

class _RadialMenuState extends State<RadialMenu>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return RadialAnimation(controller: controller);
  }
}

class RadialAnimation extends StatelessWidget {
  final AnimationController controller;
  RadialAnimation({Key key, this.controller}) : super(key: key);

  build(context) {
    return null;
  }
}
