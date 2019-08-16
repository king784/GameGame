import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_testuu/Navigation.dart';
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
                            'Syötä kysymys:',
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
                                //newQuestion = value;
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
                            'Syötä vastausvaihtoehto 1:',
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
                                //answers[0] = value;
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
                            'Syötä vastausvaihtoehto 2:',
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
                                //answers[1] = value;
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
                            'Syötä vastausvaihtoehto 3:',
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
                                // answers[2] = value;
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
                            'Syötä vastausvaihtoehto 4:',
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
                                // answers[3] = value;
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

              Text(
                'Anna oikea vastaus:',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle,
              ),
            
              // Button to submit
              Padding(
                padding: EdgeInsets.all(20),
                child: MaterialButton(
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      print(Global.pen("ADDING"));
                      AddQuestionToDB();
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

  void AddQuestionToDB() {
    // RaisedButton(
    //   child: const Text("Lisää pelaaja"),
    //   onPressed: (){
    //     Player pelaaja = new Player(22, 0, 'Trenton', 'Thompson', 'Salon Vilpas', 33);
    //     CollectionReference dbCollectionRef = Firestore.instance.collection('players');
    //     Firestore.instance.runTransaction((Transaction tx) async {
    //       var result = await dbCollectionRef.add(pelaaja.toJson());
    //     });
    //     setState(() {

    //     });
    //   },
    // ),

//     String imgName = "";
//     if (questionImage != null) {
//       imgName = questionImage.path.split('/').last;
//     }
//     Question question =
//         new Question(newQuestion, answers, (correctAnswer-1), imgName, currentDate);
//     CollectionReference dbCollectionRef =
//         Firestore.instance.collection('questions');
//     Firestore.instance.runTransaction((Transaction tx) async {
//       var result = await dbCollectionRef.add(question.toJson());
//     });

//     // Upload image to db
//     StorageReference reference =
//         FirebaseStorage.instance.ref().child('Quizes/').child('1/').child(imgName);

//     print('Reference: ' + reference.toString());

// //add picture to firebase storage
//     StorageUploadTask uploadTask = reference.putFile(questionImage);
    
//     print(Global.pen("DONE"));
//     setState(() {});
  }

  void LoadAllQuestions() async {
    // QuerySnapshot querySnapshot =
    //     await Firestore.instance.collection('questions').getDocuments();

    // List<DocumentSnapshot> questionSnapshot = new List<DocumentSnapshot>();
    // questionSnapshot = querySnapshot.documents;
    // Question tempQuestion;
    // questionSnapshot.forEach((q) {
    //   tempQuestion = new Question.fromJson(q.data);
    //   allQuestions.add(tempQuestion);
    // });

    // setState(() {});
  }
}
