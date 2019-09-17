import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'Globals.dart';

//make things work, gamecode check is shitty

class ImageVotingAdmin extends StatefulWidget {
  @override
  _ImageVotingAdminState createState() => _ImageVotingAdminState();
}

class _ImageVotingAdminState extends State<ImageVotingAdmin> {
  bool competitionStatusChecked = false;
  bool competitionIsOn = false;
  String isCompetitionOnInfo = "Kilpailu ei ole käynnissä.";

  @override
  void initState() {
    super.initState();
    getIscompetitionOn();
  }

  @override
  Widget build(BuildContext context) {
    getIscompetitionOn();
    return competitionStatusChecked
        ? Card(
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(FontAwesomeIcons.solidImage),
                  title: Text('Kuvakilpailu'),
                  subtitle: Text(
                      'Tästä voit laittaa kilpailun käyntiin ja sulkea sen.'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(isCompetitionOnInfo,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.body1),
                ),
                ButtonTheme.bar(
                  child: ButtonBar(
                    children: <Widget>[
                      competitionIsOn ? _turnOffBtn() : _startBtn(),
                    ],
                  ),
                ),
              ],
            ),
          )
        : SizedBox.shrink();
  }

  _startBtn() {
    return RaisedButton(
      child: Text('Aloita kuvakilpailu',
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.subtitle),
      onPressed: () {
        competitionOn();
      },
      color: Theme.of(context).accentColor,
    );
  }

  _turnOffBtn() {
    return RaisedButton(
      child: Text('Lopeta kuvakilpailu',
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.subtitle),
      onPressed: () {
        competitionOff();
      },
      color: Theme.of(context).accentColor,
    );
  }

  Future<void> getIscompetitionOn() async {
    //check if the competition is on
    final QuerySnapshot result = await Firestore.instance
        .collection('bestPictureCompetitionOn')
        .limit(1) //limits documents to one
        .getDocuments();
    competitionIsOn = result.documents[0]['competitionIsOn'];
    //print(result.documents[0]['competitionIsOn'].toString());
    competitionStatusChecked = true;

    setState(() {});
  }

  void competitionOn() {
    var documentRef = Firestore.instance
        .collection('bestPictureCompetitionOn')
        .document('jtw6KDaWln290FeHit9x');

    documentRef.setData({
      'competitionIsOn': true,
    });

    print(Global.greenPen("DONE"));

    Fluttertoast.showToast(
      msg: 'kilpailu käynnissä.',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 2,
    );
    setState(() {
      competitionIsOn = true;
      getIscompetitionOn();
    });
  }

  void competitionOff() {
    var documentRef = Firestore.instance
        .collection('bestPictureCompetitionOn')
        .document('jtw6KDaWln290FeHit9x');

    documentRef.setData({
      'competitionIsOn': false,
    });

    print(Global.greenPen("DONE"));

    Fluttertoast.showToast(
      msg: 'Kilpailu suljettu.',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 2,
    );
    setState(() {
      competitionIsOn = false;
      getIscompetitionOn();
    });
  }

  void getBestImageWinners() {}

  void deleteOldImages() {}
}
