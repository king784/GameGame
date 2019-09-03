import 'package:flutter/material.dart';
import 'package:flutter_testuu/Globals.dart';
import 'package:flutter_testuu/Themes/MasterTheme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'Navigation.dart';

class MenuItem {
  final String name;
  final Color color;
  final double x;
  final IconData icon;
  Function() function;

  MenuItem({this.name, this.color, this.x, this.icon});

  void givefunction(Function() f) {
    this.function = f;
  }
}

class NavBar extends StatefulWidget {
  createState() => NavBarState();
}

class NavBarState extends State<NavBar> {
  List items = [
    MenuItem(
      x: -0.75,
      name: 'user',
      color: MasterTheme.btnColours[0],
      icon: FontAwesomeIcons.user,
    ),
    MenuItem(
      x: -0.25,
      name: 'home',
      color: MasterTheme.btnColours[1],
      icon: FontAwesomeIcons.basketballBall,
    ),
    MenuItem(
      x: 0.25,
      name: 'activities',
      color: MasterTheme.btnColours[2],
      icon: FontAwesomeIcons.gamepad,
    ),
    MenuItem(
      x: 0.75,
      name: 'help',
      color: MasterTheme.btnColours[3],
      icon: FontAwesomeIcons.question,
    ),
  ];

  MenuItem active;

  @override
  void initState() {
    super.initState();
    active = items[0]; //first active item
  }

  @override
  Widget build(BuildContext context) {
    items[0].giveFunction(Navigation.openUserPage(context));
    items[0].giveFunction(Navigation.openHomePage(context));
    items[0].giveFunction(Navigation.openActivitiesPage(context));
    items[0].giveFunction(Navigation.openHelpPage(context));
    return Container(
        height: 80,
        color: MasterTheme.accentColour,
        child: Stack(
          children: <Widget>[
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              alignment: Alignment(active.x, -1),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 1000),
                height: 8,
                width: Global.SCREENWIDTH * 0.2,
                color: active.color,
              ),
            ),
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: items.map((item) {
                return _menuButton(item);
              }),
            ))
          ],
        ));
  }

  Widget _menuButton(MenuItem item) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: FloatingActionButton(
        heroTag: 'btn' + item.name,
        backgroundColor: item.color,
        onPressed: () {
          setState(() {
            active = item;
          });
          item.function();
        },
      ),
    );
  }
}
