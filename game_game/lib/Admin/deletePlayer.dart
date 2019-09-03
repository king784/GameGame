import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';

import '../Navigation.dart';
import '../Themes/MasterTheme.dart';
import 'package:flutter_testuu/Globals.dart';

import '../user.dart';

class DeletePlayerForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DeletePlayerFormState();
  }
}

class DeletePlayerFormState extends State<DeletePlayerForm> {
  var sortValue = "joopa";
  List<String> allPlayers = new List<String>();
  List<Widget> theList = new List<Widget>();
  bool loaded = false;  
  Icon searchIcon = new Icon(Icons.search);
  String searchText = "";
  final TextEditingController filter = new TextEditingController();
  List<String> lisOfAllPlayers = new List<String>();


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
                        heroTag: 'backBtn3',
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
                        'Poista pelaaja',
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Row(children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Text(
                    "Etsi pelaaja:",
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.body1,
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 150,
                      child: TextField(
                          controller: filter,
                          ),
                    ),
                    IconButton(
                      icon: searchIcon,
                      onPressed: () {
                        searchPressed();
                      },
                    ),
                  ],
                ),
              ),
            ]),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                children: TheTexts(), //JOUJOUJOUJOUJOUJOUJOUJOUOJOUOJOOOJOUO
              ),
            ),
          ],
        )),
      ),
    );
  }

  List<Widget> TheTexts() {
    theList.clear();
    if (!loaded) {
      addFilterListener();
      loadPlayers();
      loaded = true;
    }

    for (int i = 0; i < allPlayers.length; i++) {
      if(searchText == "")
      {
        theList.add(RaisedButton(
          child: Text(
            allPlayers[i],
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.button,
          ),
          onPressed: () {
            _deletePlayer(i);
          },
          color: MasterTheme.primaryColour,
        ));
      }
      else if (allPlayers[i].toLowerCase().contains(searchText.toLowerCase()))
      {
        theList.add(RaisedButton(
          child: Text(
            allPlayers[i],
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.button,
          ),
          onPressed: () {
            _deletePlayer(i);
          },
          color: MasterTheme.primaryColour,
        ));
      }
    }
    setState(() {
      
    });
    return theList;
  }

  void loadPlayers() async {
    final QuerySnapshot result = await Firestore.instance
        .collection('players')
        .getDocuments();

    for (int i = 0; i < result.documents.length; i++) {
      allPlayers.add(result.documents[i]["firstName"].toString() + " " + result.documents[i]["lastName"].toString() + " id: " + result.documents[i]["ID"].toString());
    }

    setState(() {});
  }

  _deletePlayer(int index) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Haluatko poistaa pelaajan?'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  SizedBox(
                    width: Global.SCREENWIDTH * .9,
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RaisedButton(
                        child: Text('Haluan',
                            style: Theme.of(context).textTheme.body1),
                        onPressed: () async {
                          List<String> temp = allPlayers[index].split(":");
                          temp[1] = temp[1].substring(1).trim();
                          print(temp[1]);
                          int idInt = int.parse(temp[1]);
                          await Firestore.instance.collection('players').where('ID', isEqualTo: idInt).limit(1).getDocuments().then((val){
                            val.documents[0].reference.delete();
                          });

                          print("Player at " + index.toString() + " deleted");
                          setState(() {
                            allPlayers.removeAt(index);
                            theList.clear();
                            //loadPlayers();
                            Navigator.of(context).pop(context);    
                          });
                        },
                        color: Theme.of(context).accentColor,
                      ),
                      RaisedButton(
                        child: Text('Peruuta',
                            style: Theme.of(context).textTheme.body1),
                        onPressed: () {
                          Navigator.of(context).pop(context);
                        },
                        color: MasterTheme.awayTeamColour,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
    void addFilterListener() {
    filter.addListener(() {
      if (filter.text.isEmpty) {
        setState(() {
          searchText = "";
        lisOfAllPlayers = allPlayers;
          if (searchIcon.icon == Icons.close) {
            searchIcon = new Icon(Icons.search);
          }
        });
      } else {
        setState(() {
          if (searchIcon.icon == Icons.search) {
            searchIcon = new Icon(Icons.close);
          }
          searchText = filter.text;
          print(searchText);
        });
      }
    });
  }
    void searchPressed() {
    setState(() {
      print("search");
      if (searchIcon.icon == Icons.search) {
        searchIcon = new Icon(Icons.close);
      } else {
        searchIcon = new Icon(Icons.search);
        lisOfAllPlayers = allPlayers;
        filter.clear();
      }
    });
  }
  
}