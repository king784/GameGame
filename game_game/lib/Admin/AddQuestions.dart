import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';

import '../Themes/MasterTheme.dart';
import 'package:flutter_testuu/Globals.dart';

class AddQuestionForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddQuestionFormState();
  }
}

class AddQuestionFormState extends State<AddQuestionForm> {
  final formKey = GlobalKey<FormState>();
  DateTime currentDate;
  File questionImage;
  bool imageLoaded = false;
  String newQuestion;
  List<String> answers = new List<String>(4);
  int correctAnswer = 4;

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
          body: Column(
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
              Expanded(
                child: Container(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(5, 5, 5, 50),
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Kysymyskenttä on tyhjä.';
                                          } else {
                                            newQuestion = value;
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(5, 5, 5, 50),
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Kenttä on tyhjä.';
                                          } else {
                                            answers[0] = value;
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(5, 5, 5, 50),
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Kenttä on tyhjä.';
                                          } else {
                                            answers[1] = value;
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(5, 5, 5, 50),
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Kenttä on tyhjä.';
                                          } else {
                                            answers[2] = value;
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(5, 5, 5, 50),
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Kenttä on tyhjä.';
                                          } else {
                                            answers[3] = value;
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

                          Padding(
                            padding: EdgeInsets.fromLTRB(5, 5, 5, 10),
                            child: Text(
                              'Anna oikea vastaus:',
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.subtitle,
                            ),
                          ),

                          // Date picker
                          Theme(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(5, 5, 5, 50),
                                child: NumberPicker.integer(
                                    highlightSelectedValue: true,
                                    initialValue: correctAnswer,
                                    minValue: 1,
                                    maxValue: 4,
                                    onChanged: (newValue) {
                                      correctAnswer = newValue;
                                      setState(() {});
                                    }),
                              ),
                            ),
                            data: ThemeData(
                              accentColor: MasterTheme.accentColour,
                              textTheme: TextTheme(
                                headline:
                                    TextStyle(color: MasterTheme.accentColour),
                                body1:
                                    TextStyle(color: MasterTheme.primaryColour),
                              ),
                            ),
                          ),

                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: RaisedButton(
                                  color: MasterTheme.primaryColour,
                                  onPressed: () {
                                    DatePicker.showDatePicker(context,
                                        showTitleActions: true,
                                        minTime: DateTime.now(),
                                        maxTime: DateTime(2020, 6, 1),
                                        onChanged: (date) {
                                      currentDate = date;
                                    }, onConfirm: (date) {
                                      currentDate = date;
                                      setState(() {});
                                      // The fi Localetype was not part of the DatePicker package.
                                    },
                                        currentTime: DateTime.now(),
                                        locale: LocaleType.fi);
                                  },
                                  child: Text(
                                    'Valitse ottelun päivä',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.button,
                                  )),
                            ),
                          ),

                          currentDate != null
                              ? Center(
                                  child: Text("Valittu päivä: " +
                                      DateFormat("dd-MM-yyyy")
                                          .format(currentDate)
                                          .toString()),
                                )
                              : Center(
                                  child: Text("Päivää ei ole valittu"),
                                ),

                          // Image for quiz
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: RaisedButton(
                                color: MasterTheme.primaryColour,
                                child: Text(
                                  "Lisää kuva",
                                  style: Theme.of(context).textTheme.button,
                                ),
                                onPressed: () {
                                  GetQuestionImage();
                                },
                              ),
                            ),
                          ),

                          !imageLoaded
                              ? SizedBox.shrink()
                              : Column(
                                  children: <Widget>[
                                    Text("Valittu kuva: "),
                                    SizedBox(
                                      width: Global.SCREENWIDTH * 0.8,
                                      child: Image.file(questionImage),
                                    ),
                                  ],
                                ),

                          // Button to submit
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: MaterialButton(
                              onPressed: () {
                                if (formKey.currentState.validate()) {
                                  print(Global.greenPen("ADDING"));
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
                                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child:
                                        Icon(FontAwesomeIcons.questionCircle),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void GetQuestionImage() async {
    questionImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    imageLoaded = true;
    setState(() {});
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

    String imgName = "";
    if (questionImage != null) {
      imgName = questionImage.path.split('/').last;
    }
    Question question = new Question(
        newQuestion, answers, (correctAnswer - 1), imgName, currentDate);
    CollectionReference dbCollectionRef =
        Firestore.instance.collection('questions');
    Firestore.instance.runTransaction((Transaction tx) async {
      var result = await dbCollectionRef.add(question.toJson());
    });

    if (imgName != "") {
      // Upload image to db
      StorageReference reference = FirebaseStorage.instance
          .ref()
          .child('Quizes/')
          .child('1/')
          .child(imgName);

      print('Reference: ' + reference.toString());

//add picture to firebase storage
      StorageUploadTask uploadTask = reference.putFile(questionImage);
    }

    print(Global.greenPen("DONE"));

    Fluttertoast.showToast(
      msg: 'Kysymys lisätty',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 2,
    );
    setState(() {});
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
