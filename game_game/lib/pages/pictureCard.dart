import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_testuu/Globals.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PictureCardList extends StatefulWidget {
  @override
  _PictureCardListState createState() => _PictureCardListState();
}

class _PictureCardListState extends State<PictureCardList> {
  List<imageFromDB> allimages = new List<imageFromDB>();
  List<Card> imageCardList = new List<Card>();
  bool imagesLoaded = false;
  bool firstRun = true;

  @override
  void initState() {
    super.initState();
    loadImagesFromDB();
  }

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
        : Column(children: imageCardList);
  }

  _cardWithPic(String photographersUsername, String imgUrl, int votes) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(
              width: Global.SCREENWIDTH * 0.9,
              child: Image.network(imgUrl),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Text(
                            'Kuvaaja:',
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.body1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Text(
                            photographersUsername,
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.display4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          'Saadut äänet:',
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.body1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          votes.toString(),
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.display4,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: RaisedButton(
                      child: Icon(
                        FontAwesomeIcons.plus,
                      ),
                      onPressed: () => {},
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> makeWidgetListFromPictures() async {
    imageCardList.clear();
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
    //listen to changes and update images after first time
    var res = await Firestore.instance
        .collection('imagesForBestImageVoting')
        .snapshots();

    imageFromDB tempImg;

    res.listen((data) {
      print("Listening to db for image changes");
      allimages.clear();
      //get the documents from firestore and make a new tempimg from each changed document
      data.documentChanges.forEach((change) {
        print("pictures should have been added");
        tempImg = new imageFromDB(change.document['photographerName'],
            change.document['imgUrl'], change.document['totalVotes']);
        //see if there is an old image with same path and photographer in  the allimagews list and save the index
        int queryIndex = allimages.indexWhere((img) =>
            img.photographerName == tempImg.photographerName &&
            img.imgUrl == tempImg.imgUrl);
        if (queryIndex >= 0) {
          //if an image with same uploader and path/filename was found
          if (tempImg.totalVotes > allimages[queryIndex].totalVotes) {
            //if the image from db has more votes than the temp image
            //just to make it clear the temp image is the never version of the found image query
            //update the old image
            allimages[queryIndex] = tempImg;
          }
        } else {
          //the same image was not found
          // add the new image to allimages list
          if (!firstRun) {
            allimages.add(tempImg);
          }
        }
        makeWidgetListFromPictures();
      });
    });

    final QuerySnapshot result = await Firestore.instance
        .collection(
            'imagesForBestImageVoting') //get the documents from this collection
        .getDocuments();

    for (int i = 0; i < result.documents.length; i++) {
      //go through all the documents we got from firestore
      allimages.add(new imageFromDB(result.documents[i]['photographerName'],
          result.documents[i]['imgUrl'], result.documents[i]['totalVotes']));
      //print(allimages[i].toString());
    }

    if (allimages != null) {
      allimages.sort((a, b) => a.totalVotes.compareTo(b.totalVotes));
      allimages = allimages.reversed.toList();
      print("Total votes: " + allimages[1].totalVotes.toString());
      await makeWidgetListFromPictures();
      imagesLoaded = true;
    }
    firstRun = false;
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

  Map<String, dynamic> toJson() => {
        'photographerName': photographerName,
        'imgUrl': imgUrl,
        'totalVotes': totalVotes
      };
}
