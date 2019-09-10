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

class AddGameCodeForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddGameCodeFormState();
  }
}

class AddGameCodeFormState extends State<AddGameCodeForm> {
  final formKey = GlobalKey<FormState>();
  String gameCode;
  DateTime codeDate;

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
                          heroTag: 'backBtn8',
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
                          'Pelikoodien lisäys',
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
                                        'Pelikoodi:',
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
                                            return 'Koodinsyöttökenttä on tyhjä.';
                                          } else {
                                            gameCode = value;
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

                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: RaisedButton(
                                  color: MasterTheme.accentColour,
                                  onPressed: () {
                                    DatePicker.showDatePicker(context,
                                        showTitleActions: true,
                                        minTime: DateTime.now(),
                                        maxTime: DateTime(2020, 6, 1),
                                        onChanged: (date) {
                                      codeDate = date;
                                    }, onConfirm: (date) {
                                      codeDate = date;
                                      setState(() {});
                                      // The fi Localetype was not part of the DatePicker package.
                                    },
                                        currentTime: DateTime.now(),
                                        locale: LocaleType.fi);
                                  },
                                  child: Text(
                                    'Valitse koodin päivä',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.button,
                                  )),
                            ),
                          ),

                          codeDate != null
                              ? Center(
                                  child: Text("Valittu päivä: " +
                                      DateFormat("dd-MM-yyyy")
                                          .format(codeDate)
                                          .toString()),
                                )
                              : Center(
                                  child: Text("Päivää ei ole valittu"),
                                ),

                          // Button to submit
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: MaterialButton(
                              onPressed: () {
                                if (formKey.currentState.validate()) {
                                  print(Global.greenPen("ADDING"));
                                  AddCodeToDB();
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
                                    child: Text("Lisää koodi"),
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

  void AddCodeToDB() {
    CollectionReference dbCollectionRef =
        Firestore.instance.collection('gameCodes');
    Firestore.instance.runTransaction((Transaction tx) async {
      var result = await dbCollectionRef.add({'code': gameCode,
      'date': DateFormat("dd-MM-yyyy").format(codeDate).toString()
      });
    });

    print(Global.greenPen("DONE"));

    Fluttertoast.showToast(
      msg: 'Koodin lisätty',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 2,
    );
    setState(() {});
  }
}
