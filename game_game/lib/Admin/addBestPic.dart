import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_testuu/Admin/admin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';

import '../Navigation.dart';
import '../Themes/MasterTheme.dart';
import 'package:flutter_testuu/Globals.dart';

import '../user.dart';

class WinnerPicture extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WinnerPictureState();
  }
}

class WinnerPictureState extends State<WinnerPicture> {
  FirebaseStorage _storage = FirebaseStorage.instance;
  bool deleteComplete = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Theme(
        data: MasterTheme.mainTheme,
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Poistetaan kuvia..."),

            ],
          ),
        ),
      ),
    );
  }

  void safeWinner() async {
    //DIIBADAABA...
    StorageReference ref = _storage.ref().child("bestPictureCompetition/");

    //StorageUploadTask uploadTask = ref.putFile()
    deletePictures();
  }

  void deletePictures() {

  }
}
