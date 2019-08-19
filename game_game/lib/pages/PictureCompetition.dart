import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_testuu/Globals.dart';
import 'package:flutter_testuu/Themes/MasterTheme.dart';
import 'package:flutter_testuu/pages/pictureCard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../Navigation.dart';

class PictureCompetition extends StatefulWidget {
  @override
  _PictureCompetitionState createState() => _PictureCompetitionState();
}

class _PictureCompetitionState extends State<PictureCompetition> {
  bool competitionStatusChecked = false;
  bool competitionIsOn = false; //get this from database
  bool pictureAdded = false; //get this from the user

  @override
  void initState() {
    super.initState();
    getIscompetitionOn();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //onwill popscope disables the use of the android back button
      onWillPop: () async => false,
      child: Theme(
        data: MasterTheme.mainTheme,
        child: Scaffold(
          body: _content(),
        ),
      ),
    );
  }

  _content() {
    if (competitionStatusChecked) {
      return Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
              child: Container(
                color: MasterTheme.accentColour,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(2, 10, 10, 10),
                      child: FloatingActionButton(
                          heroTag: 'backBtn2',
                          child: Icon(
                            FontAwesomeIcons.arrowLeft,
                            color: MasterTheme.primaryColour,
                            size: 40,
                          ),
                          backgroundColor: Colors.transparent,
                          onPressed: () =>
                              Navigation.openActivitiesPage(context),
                          // onPressed: () => Navigation.openPage(context, 'activities'),
                          elevation: 0),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Kuvaäänestys',
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.title,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          _addingPictureWidget(),
          Expanded(
            child: Container(
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
            padding: const EdgeInsets.all(100),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text('Tarkistetaan kilpailun tilaa..',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.caption),
              ),
            ),
          ),
        ],
      );
    }
  }

  _addingPictureWidget() {
    //let user add their own pic if they haven't done it yet
    if (!competitionIsOn) {
      return Text("");
    } else {
      if (!pictureAdded) {
        return Padding(
          padding: const EdgeInsets.all(15),
          child: SizedBox(
            height: 70,
            child: RaisedButton(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text('Lisää tästä oma kuvasi kisaan',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.subtitle),
                  ),
                  Icon(
                    FontAwesomeIcons.solidImage,
                    size: 50,
                  ),
                ],
              ),
              onPressed: () => _createImagePopUpDialog(context),
              color: Theme.of(context).accentColor,
            ),
          ),
        );
      } else {
        return Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text('Olet jo lisännyt oman kuvasi kisaan. Onnea!',
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.caption),
          ),
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
          Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text('Kilpailu ei ole juuri nyt käynnissä.',
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.caption),
            ),
          )
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

//help from here https://youtu.be/7uqmY6le4xk

  choosePictureToAdd() async {
    //use the image picker to choose a file from phone's gallery and wait until it's done
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    //for debugging
    print(image.path);
  }

  _createImagePopUpDialog(BuildContext context) async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Lisää kuva'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                SizedBox(
                  width: Global.SCREENWIDTH * .5,
                  child: Image.file(image),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RaisedButton(
                      child: Text('Lähetä',
                          style: Theme.of(context).textTheme.body1),
                      onPressed: () {
                        _addFileToDatabase(image); //add the image to database
                        Navigator.of(context).pop(context);
                      },
                      color: Theme.of(context).accentColor,
                    ),
                    RaisedButton(
                      child: Text('Ei sittenkään',
                          style: Theme.of(context).textTheme.body1),
                      onPressed: () {
                        Navigator.of(context).pop(context);
                      }, //close popup
                      color: MasterTheme.awayTeamColour,
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

  _addFileToDatabase(File img) async {
    //https://stackoverflow.com/questions/51857796/flutter-upload-image-to-firebase-storage

    //firebase storage reference
    FirebaseStorage _storage = FirebaseStorage.instance;
    String downloadUrl;

//filename
    String imgName = img.path.split('/').last;
    print('image name: ' + imgName);

    //reference to the location/file folder in firestorage
    StorageReference reference =
        _storage.ref().child('bestPictureCompetition/').child(imgName);

    //print('Reference: ' + reference.toString());

//add picture to firebase storage
    StorageUploadTask uploadTask = reference.putFile(img);
    // await reference.putFile(img).onComplete.then((val) {
    //   val.ref.getDownloadURL().then((val) {
    //     print(val);
    //     downloadUrl = val; //Val here is Already String
    //   });
    // });

//get the image download url for the image data collection
    // var downloadUrl = await reference.getDownloadURL() as String;
    // String downloadUrl = (await uploadTask.onComplete).ref.getDownloadURL().toString();
    // String downloadUrl = Uri.parse(await reference.getDownloadURL()) as String;
    reference
        .child('bestPictureCompetition/' + imgName)
        .getDownloadURL()
        .then((val) {
      downloadUrl = val.toString();
    });

//just help for this
    // StorageTaskSnapshot sts = await uploadTask.onComplete;
    // String tempDBImageUrl = await sts.ref.getDownloadURL();
    // var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    // url = dowurl.toString();

    print("\nadding image to db, download url: $downloadUrl\n");

//add picture to database document with the needed voting parameters
    await Firestore.instance
        .collection('imagesForBestImageVoting')
        .document()
        .setData(
      {
        'photographerName': 'name', //this should be the user's name
        'imgUrl': 'bestPictureCompetition/' + imgName,
        'downloadUrl': downloadUrl,
        'totalVotes': 0
      },
    );
  }
}
