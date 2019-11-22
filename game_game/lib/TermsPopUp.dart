import 'package:flutter/material.dart';

import 'Globals.dart';
import 'Themes/MasterTheme.dart';

termsPopUp(BuildContext context, {Function() function}) async {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Käyttöehdot'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              SizedBox(
                  width: Global.SCREENWIDTH * .9,
                  child: Expanded(
                    child: Text(
                        "Kirjautumalla sisään tietosi tallentuvat NSA:n sekä FBI:n tietokantaan.. :D"),
                  )),
              ButtonBar(
                alignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RaisedButton(
                    child: Text('Hyväksyn',
                        style: Theme.of(context).textTheme.body1),
                    onPressed: () {
                      agree();
                      function();
                      Navigator.of(context).pop(context);
                    },
                    color: Theme.of(context).accentColor,
                  ),
                  RaisedButton(
                    child: Text('Ei sittenkään',
                        style: Theme.of(context).textTheme.body1),
                    onPressed: () {
                      disagree();
                      Navigator.of(context).pop(context);
                    }, //close popup
                    color: MasterTheme.awayTeamColour,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

void agree() {
  print("Hyävksytty :D");
}

void disagree() {}
