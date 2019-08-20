import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_testuu/Navigation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';

import '../Themes/MasterTheme.dart';
import 'package:flutter_testuu/Globals.dart';

class AddPlayerForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddPlayerFormState();
  }
}

class AddPlayerFormState extends State<AddPlayerForm> {
  final formKey = GlobalKey<FormState>();
  int newID;
  String firstName;
  String lastName;
  int playerNum;
  String team;

  @override
  void initState() {
    super.initState();

    //LoadAllQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Theme(
        data: MasterTheme.mainTheme,
        child: Scaffold(
          body: ListView(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                      child: FloatingActionButton(
                          heroTag: 'backBtn1',
                          child: Icon(
                            FontAwesomeIcons.arrowLeft,
                            color: MasterTheme.accentColour,
                            size: 40,
                          ),
                          backgroundColor: Colors.transparent,
                          onPressed: () => Navigator.pop(context),
                          elevation: 0),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Pelaajan lisäys',
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.title,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // Question form
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            'Syötä etunimi:',
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.subtitle,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(5, 5, 5, 50),
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Kysymyskenttä on tyhjä.';
                              } else {
                                firstName = value;
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            'Syötä sukunimi:',
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.subtitle,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(5, 5, 5, 50),
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Kenttä on tyhjä.';
                              } else {
                                lastName = value;
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            'Syötä pelaajanumero:',
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.subtitle,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(5, 5, 5, 50),
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Kenttä on tyhjä.';
                              } else {
                                playerNum = int.parse(value);
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            'Syötä joukkueen nimi:',
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.subtitle,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(5, 5, 5, 50),
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Kenttä on tyhjä.';
                              } else {
                                team = value;
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Button to submit
              Padding(
                padding: EdgeInsets.all(20),
                child: MaterialButton(
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      //print(Global.greenPen("ADDING"));
                      AddPlayerToDB();
                    }
                  },
                  color: MasterTheme.accentColour,
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("Lisää pelaaja"),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(FontAwesomeIcons.questionCircle),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void AddPlayerToDB() async {
    int highestID;
    Player tempPlayer;
    final QuerySnapshot playerDocs = await Firestore.instance
        .collection('players')
        .orderBy("ID", descending: true)
        .limit(1)
        .getDocuments(); //.limit(1).getDocuments();
    // final DocumentReference playerDocRef = Firestore.instance
    //     .collection('players')
    //     .document(playerDocs.documents[0].documentID);
    highestID = playerDocs.documents[0].data['ID'];
    highestID += 1;

    print(highestID);

    Player pelaaja =
        new Player(highestID, 0, firstName, lastName, team, playerNum);
    CollectionReference dbCollectionRef =
        Firestore.instance.collection('players');
    Firestore.instance.runTransaction((Transaction tx) async {
      var result = await dbCollectionRef.add(pelaaja.toJson());
    });
    
    Fluttertoast.showToast(
      msg: 'Pelaaja lisätty',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 2,
      );
  }
}
