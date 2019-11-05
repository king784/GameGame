import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../Themes/MasterTheme.dart';

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
