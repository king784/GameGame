import 'package:flutter/material.dart';
import 'package:flutter_testuu/Themes/MasterTheme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Globals.dart';

NiceButton(String text, BuildContext context, {Function() function}) {
  double buttonWidth = Global.SCREENWIDTH * .9;
  return Padding(
    padding: const EdgeInsets.all(7.0),
    child: SizedBox(
      width: buttonWidth,
      child: RaisedButton(
        color: MasterTheme.ktpGreen,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.button,
          ),
        ),
        onPressed: () {
          function();
        },
      ),
    ),
  );
}

NiceButtonWithIcon(String text, BuildContext context, IconData icon,
    {Function() function}) {
  double buttonWidth = Global.SCREENWIDTH * .9;
  double iconSize = 50;
  return Padding(
    padding: const EdgeInsets.all(7.0),
    child: SizedBox(
      width: buttonWidth,
      child: RaisedButton(
        color: MasterTheme.ktpGreen,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.button,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Icon(
                icon,
                size: iconSize,
                color: MasterTheme.buttonColor,
              ),
            ),
          ],
        ),
        onPressed: () {
          function();
        },
      ),
    ),
  );
}

TopTitleBar(BuildContext context, String title, {Function() function}) {
  return Align(
    alignment: Alignment.topCenter,
    child: Container(
      color: MasterTheme.ktpGreen,
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
            child: IconButton(
                icon: Icon(
                  FontAwesomeIcons.arrowLeft,
                  color: MasterTheme.primaryColour,
                  size: 40,
                ),
                color: Colors.transparent,
                onPressed: () {
                  function();
                },
                tooltip: 'Takaisin'),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                title,
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.title,
              ),
            ),
          )
        ],
      ),
    ),
  );
}
