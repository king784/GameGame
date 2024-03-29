import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_testuu/Globals.dart';
import 'package:flutter_testuu/user.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'NavigationBar/Navigation.dart';
import 'Themes/MasterTheme.dart';

class StartPageForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StartPageFormState();
  }
}

class StartPageFormState extends State<StartPageForm> {
  final _formKey = GlobalKey<FormState>();
  String _currentGameCode;
  DateTime startTime;
  DateTime endTime;
  DateTime todayDT;
  bool correctGameDay = false;
  String waitText;

  @override
  void initState() {
    super.initState();
    Global.gameCodeCorrect = false;

    getGamingDay();
    getCurrentGameCode();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Syötä pelikoodi:',
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.display1
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'esim. XQ34',
                  prefixStyle: Theme.of(context).textTheme.display1,
                  labelStyle: Theme.of(context).textTheme.subhead,
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Syötä koodi, se löytyy tapahtuma-alueelta.';
                  } else if (value.toString() != _currentGameCode) {
                    print(value.toString() + ', ' + _currentGameCode);
                    return 'Antamasi koodi näyttäisi olevan väärin.';
                  } else if (value.toString() == _currentGameCode &&
                      correctGameDay) {
                    // User has visited game
                    if (checkValidDay()) {
                      User.instance.visitGame(startTime);
                    }
                    Global.gameCodeCorrect = true;
                    Navigation.openHelpPage(context);
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: MaterialButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    if (!correctGameDay) {
                      waitText = 'Tänään ei ole peliä.';
                    } else {
                      waitText = 'Odota. Luetaan...';
                    }
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text(waitText),
                      ),
                    );
                  }
                },
                color: MasterTheme.ktpGreen,
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("Tarkista",
                          style: Theme.of(context).textTheme.button),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        FontAwesomeIcons.arrowRight,
                        color: MasterTheme.primaryColour,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Future<void> getCurrentGameCode() async {
    String today = DateFormat("dd-MM-yyyy").format(DateTime.now()).toString();
    final QuerySnapshot result = await Firestore
        .instance //get collection of gamecodes where date is same today
        .collection('gameCodes')
        .where('date', isEqualTo: today)
        .limit(1) //limits documents to one where the date is same
        .getDocuments();
    String gameCode = result.documents[0][
        'code']; //get the code string from the first item in the collection, there should onbly be one document
    //print("today: " + today + ", result: " + gameCode);
    _currentGameCode = gameCode;
  }

  bool checkValidDay() {
    todayDT = DateTime.now();
    return (todayDT.isAfter(startTime) && todayDT.isBefore(endTime));
  }

  Future<void> getGamingDay() async {
    Timestamp todayTS = Timestamp.now();
    int today = DateTime.now().millisecondsSinceEpoch;
    todayDT = DateTime.now();
    final QuerySnapshot result = await Firestore
        .instance //get collection of gamecodes where date is same today
        .collection('gamingDay')
        .where('activeDay', isLessThanOrEqualTo: todayTS)
        .limit(1) //limits documents to one where the date is same
        .getDocuments();
    if (result.documents.length <= 0) {
      correctGameDay = false;
    } else {
      Timestamp day = result.documents[0]['activeDay'];
      startTime = day.toDate();
      endTime = startTime.add(Duration(hours: 3));
      correctGameDay = true;
    }
  }
}
