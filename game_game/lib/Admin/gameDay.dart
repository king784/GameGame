import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart' as prefix0;
import 'package:flutter_testuu/Navigation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';

import '../Themes/MasterTheme.dart';
import 'package:flutter_testuu/Globals.dart';

class AddGamedayForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddGamedayFormState();
  }
}

class AddGamedayFormState extends State<AddGamedayForm> {
  bool dayChanged = false;
  DateTime theDay;
  final myFormat = new DateFormat("d/M/yyyy hh:mm");

  @override
  void initState() {
    super.initState();

    //LoadAllQuestions();
  }

  @override
  Widget build(BuildContext context) {
    dayChanged == false ? theDay = DateTime.now() : print(dayChanged);
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
                          'Pelipäivän lisäys',
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.title,
                        ),
                      ),
                    )
                  ],
                ),
              ),

              Text(myFormat.format(theDay),
                textAlign: TextAlign.center,              
              ),

              // Date picker
              RaisedButton(
                  onPressed: () {
                    DatePicker.showDateTimePicker(context,
                      showTitleActions: true,
                      locale: LocaleType.en,
                      onConfirm: (date){
                        dayChanged = true;
                        setState(() {
                          theDay = date;                        
                        });
                      } 
                    );
                  },
                  child: Text(
                    'Aseta päivä.',
                    style: Theme.of(context).textTheme.subtitle,
                  )),

              // Image for quiz
              RaisedButton(
                child: Text("Hyväksy"),
                onPressed: () {
                  createGameDay();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void createGameDay() async{
    print(theDay);

    DocumentReference gamesRef = await Firestore.instance
        .collection('gamingDay')
        .document('avwqyFO6PB4WeACjYC0K');
    gamesRef.setData({"VotingStartTime": theDay});
    
    Navigator.pop(context);
  }
}
