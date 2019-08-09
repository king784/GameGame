import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_testuu/Themes/MasterTheme.dart';
import 'package:flutter_testuu/pages/pictureCard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Navigation.dart';

class PictureCompetition extends StatefulWidget {
  @override
  _PictureCompetitionState createState() => _PictureCompetitionState();
}

class _PictureCompetitionState extends State<PictureCompetition> {
  bool competitionStatusChecked = false;
  bool competitionIsOn = false; //get this from database
  bool pictureAdded = false; //get this from the user

  @override
  void initState() {
    super.initState();
    getIscompetitionOn();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //onwill popscope disables the use of the android back button
      onWillPop: () async => false,
      child: Theme(
        data: MasterTheme.mainTheme,
        child: Scaffold(
          body: _content(),
        ),
      ),
    );
  }

  _content() {
    if (competitionStatusChecked) {
      return Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
              child: Container(
                color: MasterTheme.accentColour,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(2, 10, 10, 10),
                      child: FloatingActionButton(
                          heroTag: 'backBtn2',
                          child: Icon(
                            FontAwesomeIcons.arrowLeft,
                            color: MasterTheme.primaryColour,
                            size: 40,
                          ),
                          backgroundColor: Colors.transparent,
                          onPressed: () => Navigation.openGames(context),
                          elevation: 0),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Kuvaäänestys',
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.title,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          _addingPicture(),
          Expanded(
            child: Container(
              child: SingleChildScrollView(
                child: _competitionContent(),
              ),
            ),
          )
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(100),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text('Tarkistetaan kilpailun tilaa..',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.caption),
              ),
            ),
          ),
        ],
      );
    }
  }

  _addingPicture() {
    //let user add their own pic if they haven't done it yet
    if (!competitionIsOn) {
      return Text("");
    } else {
      if (!pictureAdded) {
        return Padding(
          padding: const EdgeInsets.all(15),
          child: SizedBox(
            height: 70,
            child: RaisedButton(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text('Lisää tästä oma kuvasi kisaan',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.subtitle),
                  ),
                  Icon(
                    FontAwesomeIcons.solidImage,
                    size: 50,
                  ),
                ],
              ),
              onPressed: () => {},
              color: Theme.of(context).accentColor,
            ),
          ),
        );
      } else {
        return Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text('Olet jo lisännyt oman kuvasi kisaan. Onnea!',
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.caption),
          ),
        );
      }
    }
  }

  _competitionContent() {
    if (competitionIsOn) {
      return PictureCardList();
    } else {
      return Column(
        children: <Widget>[
          Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text('Kilpailu ei ole juuri nyt käynnissä.',
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.caption),
            ),
          )
        ],
      );
    }
  }

  Future<void> getIscompetitionOn() async {//check if the competition is on
    final QuerySnapshot result = await Firestore.instance
        .collection('bestPictureCompetitionOn')
        .limit(1) //limits documents to one
        .getDocuments();
    competitionIsOn = result.documents[0]['competitionIsOn'];
    //print(result.documents[0]['competitionIsOn'].toString());
    competitionStatusChecked = true;

    setState(() {});
  }
}
