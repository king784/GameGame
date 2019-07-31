import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_testuu/Navigation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

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

  @override
  void initState() {
    super.initState();

    getCurrentGameCode();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
              child: Text(
                'Syötä pelikoodi:',
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.subtitle,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'esim. XQ34',
                  prefixStyle: Theme.of(context).textTheme.display1,
                  labelStyle: Theme.of(context).textTheme.subhead,
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Syötä koodi, se löytyy pelialueelta.';
                  } else if (value.toString() != _currentGameCode) {
                    print(value.toString() + ', ' + _currentGameCode);
                    return 'Antamasi koodi näyttäisi olevan väärin.';
                  } else if (value.toString() == _currentGameCode) {
                    Navigation.openMainPage(context);
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
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Odota. Luetaan...'),
                      ),
                    );
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
                      child: Text("Tarkista"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(FontAwesomeIcons.arrowRight),
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
    String gameCode = result.documents[0]['code']; //get the code string from the first item in the collection, there should onbly be one document
    //print("today: " + today + ", result: " + gameCode);
    _currentGameCode = gameCode;
  }
}
