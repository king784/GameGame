import 'package:flutter/material.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart' show radians;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: Duration(milliseconds: 900), vsync: this);
  }
}

class RadialAnimation extends StatelessWidget {
  final AnimationController controller;
  final Animation<double> scale;
  final Animation<double> translation;
  final Animation<double> rotation;

  RadialAnimation({Key key, this.controller})
      : scale = Tween<double>(begin: 1.5, end: 0.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.fastOutSlowIn,
          ),
        ),
        translation = Tween<double>(begin: 0.0, end: 100.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.elasticOut,
          ),
        ),
        rotation = Tween<double>(
          begin: 0.0,
          end: 360.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.3,
              0.9,
              curve: Curves.decelerate,
            ),
          ),
        ),
        super(key: key);

  build(context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, builder) {
          return Container(
            height: 200,
            width: 170,
            child: Stack(alignment: Alignment.topLeft, children: [
              _buildButton(5, "HomeBtn",
                  color: Colors.green,
                  icon: FontAwesomeIcons.basketballBall,
                  function: () => openMainPage(context)),
              _buildButton(45, "ActivitiesBtn",
                  color: Colors.green,
                  icon: FontAwesomeIcons.dAndD,
                  function: () => openGames(context)),
              _buildButton(85, "HelpBtn",
                  color: Colors.green,
                  icon: FontAwesomeIcons.question,
                  function: () => openHelp(context)),
              Transform.scale(
                scale: scale.value -
                    1.5, // subtract the beginning value to run the opposite animation
                child: FloatingActionButton(
                  child: Icon(FontAwesomeIcons.poo),
                  heroTag: "CloseMenuBtn",
                  onPressed: _close,
                  backgroundColor: Colors.black,
                ),
              ),
              Transform.scale(
                  scale: scale.value,
                  child: FloatingActionButton(
                    child: Icon(FontAwesomeIcons.bars),
                    heroTag: "OpenMenuBtn",
                    onPressed: _open,
                    backgroundColor: Colors.green,
                  )),
            ]),
          );
        });
  }

  void _open() {
    controller.forward();
  }

  void _close() {
    controller.reverse();
  }

  openMainPage(BuildContext context) {
    Navigator.of(context).pushNamed('/home', arguments: 'home');
  }

  openHelp(BuildContext context) {
    Navigator.of(context).pushNamed('/help', arguments: 'help');
  }

  openGames(BuildContext context) {
    Navigator.of(context).pushNamed('/activities', arguments: 'activities');
  }

  _buildButton(double angle, String btnTag,
      {Color color, IconData icon, Function() function}) {
    final double rad = radians(angle);
    return Transform(
      transform: Matrix4.identity()
        ..translate(
            (translation.value) * cos(rad), (translation.value) * sin(rad)),
      child: FloatingActionButton(
          heroTag: btnTag,
          child: Icon(icon),
          backgroundColor: color,
          onPressed: () {
            _close();
            function();
          },
          elevation: 0),
    );
  }
}
