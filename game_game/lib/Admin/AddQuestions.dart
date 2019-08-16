import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_testuu/Navigation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../Themes/MasterTheme.dart';
import 'package:flutter_testuu/Globals.dart';

class AddQuestionForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddQuestionFormState();
  }
}

class AddQuestionFormState extends State<AddQuestionForm> {
  final questionKey = GlobalKey<FormState>();
  final answer1Key = GlobalKey<FormState>();
  final answer2Key = GlobalKey<FormState>();
  final answer3Key = GlobalKey<FormState>();
  final answer4Key = GlobalKey<FormState>();
  final dateKey = GlobalKey<FormState>();
  DateTime currentDate;
  File questionImage;
  String newQuestion;
  List<String> answers = new List<String>(4);

  List<Question> allQuestions = new List<Question>();

  @override
  void initState() {
    super.initState();

    LoadAllQuestions();
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
                          'Kysymyksen lisäys',
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
                key: questionKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
                      child: Text(
                        'Syötä kysymys:',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Kysymyskenttä on tyhjä.';
                          } else {
                            Navigation.openMainPage(context);
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Answer1
              Form(
                key: answer1Key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
                      child: Text(
                        'Syötä vastausvaihtoehto 1:',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Kenttä on tyhjä.';
                          } else {
                            Navigation.openMainPage(context);
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Answer2
              Form(
                key: answer2Key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
                      child: Text(
                        'Syötä vastausvaihtoehto 2:',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Kenttä on tyhjä.';
                          } else {
                            Navigation.openMainPage(context);
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Answer3
              Form(
                key: answer3Key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
                      child: Text(
                        'Syötä vastausvaihtoehto 3:',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Kenttä on tyhjä.';
                          } else {
                            Navigation.openMainPage(context);
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Answer4
              Form(
                key: answer4Key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
                      child: Text(
                        'Syötä vastausvaihtoehto 4:',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Kenttä on tyhjä.';
                          } else {
                            Navigation.openMainPage(context);
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Date picker
              FlatButton(
                  onPressed: () {
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(2019, 6, 1),
                        maxTime: DateTime(2020, 6, 1), onChanged: (date) {
                      print('change $date');
                      currentDate = date;
                    }, onConfirm: (date) {
                      print('confirm $date');
                      currentDate = date;
                      // The fi Localetype was not part of the DatePicker package.
                    }, currentTime: DateTime.now(), locale: LocaleType.fi); 
                  },
                  child: Text(
                    'Valitse aika painamalla tästä.',
                    style: Theme.of(context).textTheme.subtitle,
                  )),

              // Image for quiz
              RaisedButton(
                onPressed: (){
                  //File questionImage = await ImagePicker.pickImage(source: ImageSource.gallery);
                },
              ),
              

            
              // Button to submit
              Padding(
                padding: EdgeInsets.all(20),
                child: MaterialButton(
                  onPressed: () {
                    if (questionKey.currentState.validate()) {
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
                        child: Text("Lisää kysymys"),
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

  void GetQuestionImage() async
  {
    
  }

  void LoadAllQuestions() async {
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection('questions').getDocuments();

    List<DocumentSnapshot> questionSnapshot = new List<DocumentSnapshot>();
    questionSnapshot = querySnapshot.documents;
    Question tempQuestion;
    questionSnapshot.forEach((q) {
      tempQuestion = new Question.fromJson(q.data);
      allQuestions.add(tempQuestion);
    });

    setState(() {});
  }
}
