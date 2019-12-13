import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_testuu/user.dart';

import 'Globals.dart';
import 'Themes/MasterTheme.dart';

termsPopUp(BuildContext context,  String termsText, {Function() function}) async {
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
                  child: Text(
                      termsText)),
              ButtonBar(
                alignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RaisedButton(
                    child: Text('Hyväksyn',
                        style: Theme.of(context).textTheme.body1),
                    onPressed: () {
                      agree();
                      Navigator.of(context).pop(context);
                      function();
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
  var ref = Firestore.instance.collection("users").where('uid', isEqualTo: User.instance.uid).getDocuments().then((val){
    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot freshSnap = await transaction.get(val.documents[0].reference);
      await transaction.update(freshSnap.reference, {
        'acceptedTerms': true,
      });
    });
  });
  print("Hyävksytty :D");
}

void disagree() {}
