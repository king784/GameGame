import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../Globals.dart';
import '../imageFromDB.dart';

//make things work, gamecode check is shitty

class ImageVotingAdmin extends StatefulWidget {
  @override
  _ImageVotingAdminState createState() => _ImageVotingAdminState();
}

class _ImageVotingAdminState extends State<ImageVotingAdmin> {
  bool competitionStatusChecked = false;
  bool competitionIsOn = false;
  String isCompetitionOnInfo = "Kilpailu ei ole käynnissä.";
  String deletingText;

  @override
  void initState() {
    super.initState();
    getIscompetitionOn();
  }

  @override
  Widget build(BuildContext context) {
    getIscompetitionOn();
    return competitionStatusChecked
        ? Card(
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(FontAwesomeIcons.solidImage),
                  title: Text('Kuvakilpailu'),
                  subtitle: Text(
                      'Tästä voit laittaa kilpailun käyntiin ja sulkea sen.'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(isCompetitionOnInfo,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.body1),
                ),
                ButtonTheme.bar(
                  child: ButtonBar(
                    children: <Widget>[
                      competitionIsOn ? _turnOffBtn() : _startBtn(),
                    ],
                  ),
                ),
                (!competitionIsOn)
                    ? ListTile(
                        leading: Icon(FontAwesomeIcons.solidImage),
                        title: Text('Hae voittajakuvat'),
                        subtitle: Text(
                            'Tästä voit tallentaa voittajakuvan tietokantaan, kun kilpailu on suljettu.'),
                      )
                    : SizedBox.shrink(),
                (!competitionIsOn)
                    ? ButtonTheme.bar(
                        child: ButtonBar(
                          children: <Widget>[_winnerImgBtn()],
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          )
        : SizedBox.shrink();
  }

  _startBtn() {
    return RaisedButton(
      child: Text('Aloita kuvakilpailu',
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.subtitle),
      onPressed: () {
        competitionOn();
      },
      color: Theme.of(context).accentColor,
    );
  }

  _turnOffBtn() {
    return RaisedButton(
      child: Text('Lopeta kuvakilpailu',
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.subtitle),
      onPressed: () {
        competitionOff();
      },
      color: Theme.of(context).accentColor,
    );
  }

  _imgInfo() {
    return ListTile(
      leading: Icon(FontAwesomeIcons.solidImage),
      title: Text('Kuvakilpailu'),
      subtitle: Text('Tästä voit laittaa kilpailun käyntiin ja sulkea sen.'),
    );
  }

  _winnerImgBtn() {
    return RaisedButton(
      child: Text('Hae voittajakuva.',
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.subtitle),
      onPressed: () {
        getBestImageWinners();
      },
      color: Theme.of(context).accentColor,
    );
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

  void competitionOn() {
    var documentRef = Firestore.instance
        .collection('bestPictureCompetitionOn')
        .document('jtw6KDaWln290FeHit9x');

    documentRef.setData({
      'competitionIsOn': true,
    });

    print(Global.greenPen("DONE"));

    Fluttertoast.showToast(
      msg: 'kilpailu käynnissä.',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 2,
    );
    setState(() {
      competitionIsOn = true;
      getIscompetitionOn();
    });
  }

  void competitionOff() {
    var documentRef = Firestore.instance
        .collection('bestPictureCompetitionOn')
        .document('jtw6KDaWln290FeHit9x');

    documentRef.setData({
      'competitionIsOn': false,
    });

    print(Global.greenPen("DONE"));

    Fluttertoast.showToast(
      msg: 'Kilpailu suljettu.',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 2,
    );
    setState(() {
      competitionIsOn = false;
      getIscompetitionOn();
    });
  }

  void getBestImageWinners() async {
    //DIIBADAABA...
    setState(() {
      deletingText = "Siirretään voitto kuvaa talteen";
    });

    final QuerySnapshot imgRef = await Firestore.instance
        .collection('imagesForBestImageVoting')
        .orderBy("totalVotes", descending: true)
        .getDocuments();

    if(imgRef.documents.length <= 0)
    {
      return;
    }

    int bestVotes = imgRef.documents[0]['totalVotes'];

    List<ImageFromDB> bestImages = new List<ImageFromDB>();

    for (int i = 0; i < imgRef.documents.length; i++) {
      if (imgRef.documents[i]['totalVotes'] == bestVotes) {
        bestImages.add(new ImageFromDB.fromJson(imgRef.documents[i].data));
        bestImages[i].isWinning = true;
      }
    }

    if (bestVotes <= 0) {
      return;
    }

    String todayInString =
        DateFormat("dd-MM-yyyy").format(DateTime.now()).toString();

    FirebaseStorage storage = FirebaseStorage.instance;
    var refToImg;
    StorageReference reference;
    List<String> tempString = new List<String>();
    // Add images which won to the database
    for (int i = 0; i < bestImages.length; i++) {
      tempString.clear();
      tempString = bestImages[i].imgUrl.split('/');

      // image
      // refToImg = FirebaseStorage.instance.ref().child(bestImages[i].imgUrl);
      // var url = await refToImg.getDownloadURL();
      // Image img = Image.network(url);

      // reference =
      //   storage.ref().child('VictoryPictures/').child(todayInString).child(tempString[1]);
      //   StorageUploadTask uploadTask = reference.putFile(imgFile);

      DocumentReference bestImagesRef = Firestore.instance
          .collection("WinningImagesForImageVoting")
          .document();
      bestImagesRef.get().then((DocumentSnapshot ds) {
        bestImagesRef.setData({
          'dateTaken': bestImages[i].dateTaken,
          'downloadUrl': bestImages[i].downloadUrl,
          'imgUrl': bestImages[i].imgUrl,
          'photographerName': bestImages[i].photographerName,
          'totalVotes': bestImages[i].totalVotes,
          'isWinning': bestImages[i].isWinning
        }, merge: true);
      });
    }

    deleteOldImages(bestVotes);
  }

  void deleteOldImages(int bestVotes) async {
    setState(() {
      deletingText = "Poistetaan kuvia";
    });

    final QuerySnapshot imgRef = await Firestore.instance
        .collection('WinningImagesForImageVoting')
        .getDocuments();

    List<ImageFromDB> bestImages = new List<ImageFromDB>();

    for (int i = 0; i < imgRef.documents.length; i++) {
      bestImages.add(new ImageFromDB.fromJson(imgRef.documents[i].data));
    }

   // Loop and delete images which are not winning images.
    var imagesRef = await Firestore.instance
        .collection('imagesForBestImageVoting')
        .getDocuments();

    // Delete values from database. Also delete the image if it is not a winning image.
    for (int i = 0; i < imagesRef.documents.length; i++) {
      if (imagesRef.documents[i]['totalVotes'] != bestVotes) {
        FirebaseStorage.instance
            .ref()
            .child(imagesRef.documents[i]['imgUrl'])
            .delete()
            .then((_) => print('Successfully deleted item'));
      }
      await Firestore.instance
          .runTransaction((Transaction myTransaction) async {
        await myTransaction.delete(imagesRef.documents[i].reference);
      });
    }

    if (bestVotes <= 0) {
      return;
    }
  }
}
