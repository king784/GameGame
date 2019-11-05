import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../Themes/MasterTheme.dart';

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
                color: MasterTheme.accentColour,
                  onPressed: () {
                    DatePicker.showDateTimePicker(context,
                      showTitleActions: true,
                      locale: LocaleType.fi,
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
                color: MasterTheme.accentColour,
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
    gamesRef.setData({"activeDay": theDay});
    
    Navigator.pop(context);
  }
}
