import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PictureCardList extends StatefulWidget {
  @override
  _PictureCardListState createState() => _PictureCardListState();
}

class _PictureCardListState extends State<PictureCardList> {
  List<imageFromDB> allimages = new List<imageFromDB>();
  List<Card> imageCardList = new List<Card>();
  bool imagesLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadImagesFromDB();
  }

//fix the images that aren't loading

  @override
  Widget build(BuildContext context) {
    return !imagesLoaded
        ? Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text('Odota, ladataan kuvia.',
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.caption),
            ),
          )
        : Column(
            children: imageCardList,
          );
  }

  _cardWithPic(String photographersUsername, String imgUrl, int votes) {
    return Card(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Image.network(imgUrl),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(
                      'Saadut äänet:',
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.body1,
                    ),
                    Text(
                      votes.toString(),
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.subhead,
                    ),
                    RaisedButton(
                      child: Icon(FontAwesomeIcons.plus),
                      onPressed: () => {},
                      color: Theme.of(context).accentColor,
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> makeWidgetListFromPictures() async {
    String tempDBImageUrl = "";
    for (int i = 0; i < allimages.length; i++) {
      var firebaseInstanceReference =
          FirebaseStorage.instance.ref().child(allimages[i].imgUrl);
      tempDBImageUrl = await firebaseInstanceReference.getDownloadURL();
      imageCardList.add(_cardWithPic(allimages[i].photographerName,
          tempDBImageUrl, allimages[i].totalVotes));
    }
    setState(() {});
  }

  void loadImagesFromDB() async {
    //remember to update list after someone votes a pic
    final QuerySnapshot result = await Firestore
        .instance //get collection of gamecodes where date is same today
        .collection('imagesForBestImageVoting')
        .getDocuments();
    //String gameCode = result.documents[0]['code'];
    for (int i = 0; i < result.documents.length; i++) {
      //go through all the documents we got from firestore
      allimages.add(new imageFromDB(result.documents[i]['photographerName'],
          result.documents[i]['imgUrl'], result.documents[i]['totalVotes']));
      print(allimages[i].toString());
    }
    makeWidgetListFromPictures();
  }
}

class imageFromDB {
  String photographerName;
  String imgUrl;
  int totalVotes;

  imageFromDB(this.photographerName, this.imgUrl, this.totalVotes);

  @override
  String toString() {
    return photographerName + ", " + imgUrl + ", " + totalVotes.toString();
  }
}
