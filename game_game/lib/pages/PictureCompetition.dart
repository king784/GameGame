import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_testuu/Assets/visualAssets.dart';
import 'package:flutter_testuu/Globals.dart';
import 'package:flutter_testuu/NavigationBar/Navigation.dart';
import 'package:flutter_testuu/Themes/MasterTheme.dart';
import 'package:flutter_testuu/pages/pictureCard.dart';
import 'package:flutter_testuu/user.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class PictureCompetition extends StatefulWidget {
  @override
  _PictureCompetitionState createState() => _PictureCompetitionState();
}

class _PictureCompetitionState extends State<PictureCompetition> {
  bool competitionStatusChecked = false;
  bool competitionIsOn = false; //get this from database
  bool pictureAdded = true; //get this from the user
  bool pictureAddedCheck = false;

  @override
  void initState() {
    super.initState();
    getIscompetitionOn();
    getIsPictureAdded();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //onwill popscope disables the use of the android back button
      onWillPop: () async => false,
      child: Theme(
        data: MasterTheme.mainTheme,
        child: Scaffold(
          body: SafeArea(
            child: _content(),
          ),
        ),
      ),
    );
  }

  _content() {
    if (competitionStatusChecked) {
      return Column(
        children: <Widget>[
          TopTitleBar(context, 'Kuvaäänestys', function: () {
            Navigation.openActivitiesPage(context);
          }),
          _addingPictureWidget(),
          Expanded(
            child: Container(
              color: MasterTheme.ktpGreen,
              child: SingleChildScrollView(                
                child: _competitionContent(),
              ),
            ),
          )
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text('Tarkistetaan kilpailun tilaa..',
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.caption),
          ),
        ],
      );
    }
  }

  _addingPictureWidget() {
    //let user add their own pic if they haven't done it yet
    if (!competitionIsOn) {
      return SizedBox.shrink();
    } else {
      if (!pictureAdded && pictureAddedCheck) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: NiceButtonWithIcon('Lisää tästä oma kuvasi kisaan', context,
              FontAwesomeIcons.solidImage, function: () {
            _createImagePopUpDialog(context);
          }),
        );
      } else if (!pictureAddedCheck) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircularProgressIndicator(),
        );
      } else {
        return Padding(
          padding: EdgeInsets.all(8),
          child: Text('Olet jo lisännyt oman kuvasi kisaan. Onnea!',
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.caption),
        );
      }
    }
  }

  _competitionContent() {
    if (competitionIsOn) {
      return PictureCardList();
    } else {
      return Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: Text('Kilpailu ei ole juuri nyt käynnissä.',
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.subhead),
          ),
        ],
      );
    }
  }

  Future<void> getIscompetitionOn() async {
    //check if the competition is on
    final QuerySnapshot result = await Firestore.instance
        .collection('bestPictureCompetitionOn')
        .limit(1) //limits documents to one
        .getDocuments();
    competitionIsOn = result.documents[0]['competitionIsOn'];
    //print(result.documents[0]['competitionIsOn'].toString());
    competitionStatusChecked = true;

    setState(() {});
  }

  Future<void> getIsPictureAdded() async {
    //check if the competition is on
    final QuerySnapshot result = await Firestore.instance
        .collection('users')
        .where('uid', isEqualTo: User.instance.uid)
        .limit(1)
        .getDocuments();
    pictureAdded = result.documents[0]['picturesAddedForCompetition'];
    //print(result.documents[0]['competitionIsOn'].toString());
    pictureAddedCheck = true;

    setState(() {});
  }

//help from here https://youtu.be/7uqmY6le4xk

  choosePictureToAdd() async {
    //use the image picker to choose a file from phone's gallery and wait until it's done
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery); //needs null check

    //for debugging
    print(image.path);
  }

  _createImagePopUpDialog(BuildContext context) async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    return image == null
        ? SizedBox.shrink()
        : showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AlertDialog(
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('Lisää kuva',
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.display1),
                      SizedBox(
                        width: Global.SCREENWIDTH * .9,
                        child: Image.file(image),
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RaisedButton(
                            child: Text('Lähetä',
                                style: Theme.of(context).textTheme.button),
                            onPressed: () {
                              //add the image to database
                              _addFileToDatabase(image);
                              updatePictureAdded(true);
                              Navigator.of(context).pop(context);
                            },
                            color: MasterTheme.ktpGreen,
                          ),
                          RaisedButton(
                            child: Text('Ei sittenkään',
                                style: Theme.of(context).textTheme.button),
                            onPressed: () {
                              Navigator.of(context).pop(context);
                            }, //close popup
                            color: MasterTheme.accentColour,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  updatePictureAdded(bool b) async {
    pictureAdded = b;
    User.instance.pictureAddedForCompetition = b;
    //database as well
    await Firestore.instance
        .collection('users')
        .where('uid', isEqualTo: (User.instance.uid))
        .limit(1)
        .getDocuments()
        .then((val) {
      Firestore.instance.runTransaction((transaction) async {
        //update the info in the document in database
        DocumentSnapshot freshSnap = await transaction.get(val.documents[0]
            .reference); //get the reference  to our document we want to update
        await transaction.update(freshSnap.reference, {
          'picturesAddedForCompetition': b,
        });
      });
    });

    setState(() {});
  }

  _addFileToDatabase(File img) async {
    //https://stackoverflow.com/questions/51857796/flutter-upload-image-to-firebase-storage

    //firebase storage reference
    FirebaseStorage _storage = FirebaseStorage.instance;
    String downloadUrl;

//filename
    String imgName = img.path.split('/').last;
    print('image name: ' + imgName);

    var imagesRef = await Firestore.instance
        .collection('imagesForBestImageVoting')
        .where('imgUrl', isEqualTo: ("bestPictureCompetition/" + imgName))
        .limit(1)
        .getDocuments();

    // Number to add to name
    int indexAddon = 0;
    do {
      imgName = indexAddon.toString() + imgName;
      indexAddon++;
      imagesRef = await Firestore.instance
          .collection('imagesForBestImageVoting')
          .where('imgUrl', isEqualTo: ("bestPictureCompetition/" + imgName))
          .limit(1)
          .getDocuments();
    } while (imagesRef.documents.length > 0);

    //reference to the location/file folder in firestorage
    StorageReference reference =
        _storage.ref().child('bestPictureCompetition/').child(imgName);

    //print('Reference: ' + reference.toString());

//add picture to firebase storage
    StorageUploadTask uploadTask = reference.putFile(img);

    await uploadTask.onComplete.then((val) async {
      //when uploading is complete
      downloadUrl =
          await val.ref.getDownloadURL(); //wait to get the url at first
      //print('Download Url: ' + downloadUrl);
    }).then((onValue) async {
      //when the download url has been gotten
      //add picture to database document with the needed voting parameters
      String photographerName = User.instance.displayName;
      if (photographerName == null || photographerName == '') {
        photographerName = 'MIA';
      }

      await Firestore.instance
          .collection('imagesForBestImageVoting')
          .document()
          .setData({
        'photographerName': User.instance
            .displayName, //this should be the user's name. User.instance.displayName
        'photographerID': User.instance.uid,
        'imgUrl': 'bestPictureCompetition/' + imgName,
        'downloadUrl': downloadUrl,
        'totalVotes': 0,
        'dateTaken': DateFormat("dd-MM-yyyy").format(DateTime.now()).toString(),
        'isWinning': false
      });
      //print("\nadding image to db, download url: $downloadUrl\n");
    });
  }
}
