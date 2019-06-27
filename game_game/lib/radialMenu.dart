import 'package:flutter/material.dart';
import 'package:flutter_testuu/Themes/MasterTheme.dart';
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
  final Color iconColour = Colors.black;
  static int btnIndex = 0;

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
            height: 150,
            width: 170,
            margin: EdgeInsets.fromLTRB(20, 45,0,0),
            child: Stack(alignment: Alignment.topLeft, children: [
              _buildButton(5,
                  color: MasterTheme.btnColours[0],
                  icon: FontAwesomeIcons.basketballBall,
                  function: () => openMainPage(context)),
              _buildButton(45,
                  color: MasterTheme.btnColours[1],
                  icon: FontAwesomeIcons.gamepad,
                  function: () => openGames(context)),
              _buildButton(90,
                  color: MasterTheme.btnColours[2],
                  icon: FontAwesomeIcons.question,
                  function: () => openHelp(context)),
              Transform.scale(
                scale: scale.value -
                    1.5, // subtract the beginning value to run the opposite animation
                child: FloatingActionButton(
                  child: Icon(
                    FontAwesomeIcons.poo,
                    color: iconColour,
                  ),
                  heroTag: "CloseMenuBtn",
                  onPressed: _close,
                  backgroundColor: MasterTheme.accentColour,
                ),
              ),
              Transform.scale(
                  scale: scale.value,
                  child: FloatingActionButton(
                    child: Icon(FontAwesomeIcons.bars, color: iconColour),
                    heroTag: "OpenMenuBtn",
                    onPressed: _open,
                    backgroundColor: MasterTheme.primaryColour,
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

  _buildButton(double angle,
      {Color color, IconData icon, Function() function}) {
    final double rad = radians(angle);
    btnIndex++;
    return Transform(
      transform: Matrix4.identity()
        ..translate(
            (translation.value) * cos(rad), (translation.value) * sin(rad)),
      child: FloatingActionButton(
          heroTag: 'btn' + btnIndex.toString(),
          child: Icon(
            icon,
            color: Colors.black,
          ),
          backgroundColor: color,
          onPressed: () {
            _close();
            function();
          },
          elevation: 0),
    );
  }
}
