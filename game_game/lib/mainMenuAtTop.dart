import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_testuu/Globals.dart';
import 'package:flutter_testuu/Themes/MasterTheme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'Navigation.dart';
import 'UserAndLocation.dart';

class MenuItem {
  final String name;
  final Color color;
  final double x;
  final IconData icon;

  MenuItem({this.name, this.color, this.x, this.icon});
}

class NavBar extends StatefulWidget {
  createState() => NavBarState();
}

class NavBarState extends State<NavBar> {
  static int activeIndex =
      3; //page that is active at the start, starts from help page so 3
  bool gameDay = false;
  bool gameDayHasBeenChecked = false;

  List items = [
    MenuItem(
      x: -1.0,
      name: 'user',
      color: MasterTheme.btnColours[0],
      icon: FontAwesomeIcons.user,
    ),
    MenuItem(
      x: -0.33,
      name: 'home',
      color: MasterTheme.btnColours[1],
      icon: FontAwesomeIcons.basketballBall,
    ),
    MenuItem(
      x: 0.33,
      name: 'activities',
      color: MasterTheme.btnColours[2],
      icon: FontAwesomeIcons.gamepad,
    ),
    MenuItem(
      x: 1.0,
      name: 'help',
      color: MasterTheme.btnColours[3],
      icon: FontAwesomeIcons.question,
    ),
  ];

  MenuItem active;

  @override
  void initState() {
    super.initState();
    active = items[activeIndex]; //first active item
  }

  @override
  Widget build(BuildContext context) {
    if (!gameDayHasBeenChecked) {
      //check if today is a gaming day, but only once
      getCompetitionDay();
    }
    return Container(
      height: 80,
      child: Stack(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                _menuButton(items[0], function: () {
                  activeIndex = 0;
                  Navigation.openUserPage(context);
                }),
                _menuButton(items[1], function: () {
                  activeIndex = 1;
                  Navigation.openHomePage(context);
                }),
                _menuButton(items[2], function: () {
                  activeIndex = 2;
                  Navigation.openActivitiesPage(context);
                }),
                _menuButton(items[3], function: () {
                  activeIndex = 3;
                  Navigation.openHelpPage(context);
                }),
              ],
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            alignment: Alignment(active.x, 1),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              height: 8,
              width: Global.SCREENWIDTH * 0.25,
              color: active.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuButton(MenuItem item, {Function() function}) {
    if (gameDay) {
      return Padding(
        padding: EdgeInsets.fromLTRB(
          0,
          10,
          0,
          10,
        ),
        child: AspectRatio(
          aspectRatio: 1,
          child: IconButton(
            iconSize: 40,
            color: Colors.transparent,
            //if user location is ok and today is a game day button has function if not function is null and button will be disabled
            onPressed: UserLocation.userLocOkForMenu && Global.gameCodeCorrect
                ? () {
                    setState(() {
                      active = item;
                    });
                    function();
                  }
                : () {},
            icon: Icon(
              item.icon,
              color: item.color,
            ),
          ),
        ),
      );
    } else if (item.name == "user" && !gameDay) {
      //users should be able to see their own profiles even when there's no game day
      return Padding(
        padding: EdgeInsets.fromLTRB(
          0,
          10,
          0,
          10,
        ),
        child: AspectRatio(
          aspectRatio: 1,
          child: IconButton(
            iconSize: 40,
            color: Colors.transparent,
            //if user location is ok and today is a game day button has function if not function is null and button will be disabled
            onPressed: () {
              setState(() {
                active = item;
              });
              function();
            },
            icon: Icon(
              item.icon,
              color: item.color,
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.fromLTRB(
          0,
          10,
          0,
          10,
        ),
        child: AspectRatio(
          aspectRatio: 1,
          child: IconButton(
            iconSize: 40,
            color: Colors.transparent,
            //if user location is ok and today is a game day button has function if not function is null and button will be disabled
            onPressed: UserLocation.userLocOkForMenu &&
                    Global.gameCodeCorrect &&
                    gameDay
                ? () {
                    setState(() {
                      active = item;
                    });
                    function();
                  }
                : () {},
            icon: Icon(
              item.icon,
              color: item.color,
            ),
          ),
        ),
      );
    }
  }

  //check if today's a game day
  Future<void> getCompetitionDay() async {
    //check if the competition is on
    final QuerySnapshot result =
        await Firestore.instance //get the gaing day collection from firebase
            .collection('gamingDay')
            .limit(1) //limits documents to one
            .getDocuments();
    Timestamp gamingDay =
        result.documents[0]['activeDay']; //convert the gotten value to date
    //print("Game day: " +gamingDay.toDate().toString() +", today is: " + DateTime.now().toString());

    if (areDatesSame(gamingDay.toDate(), DateTime.now())) {
      //check agains today
      gameDay = true;
    }

    gameDayHasBeenChecked = true;
    setState(() {});
  }

  bool areDatesSame(DateTime first, DateTime second) {
    if (first.year == second.year) {
      if (first.month == second.month) {
        if (first.day == second.day) {
          return true;
        }
      }
    }
    return false;
  }
}
