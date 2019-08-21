import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_testuu/Globals.dart';
import 'package:flutter_testuu/Themes/MasterTheme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../imageFromDB.dart';

class PictureCardList extends StatefulWidget {
  @override
  _PictureCardListState createState() => _PictureCardListState();
}

class _PictureCardListState extends State<PictureCardList> {
  bool pictureCardsLoaded = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          Firestore.instance.collection('imagesForBestImageVoting').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          // print('stream builder has an error');
          return Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text('Error: ${snapshot.error}',
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.caption),
            ),
          );
        }
        // print('Inside stream builder.');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text('Odota...\nKuvia ladataan',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.caption),
              ),
            );
            break;
          default:
            // print('streambuilder switch case default, card should be returning');
            List<Widget> imgCardList =
                new List<Widget>(); //lis tto hold the imagecards
            List<ImageFromDB> imgList = snapshot.data
                .documents //map the data from the gotten documents to imagefromdb
                .map<ImageFromDB>((DocumentSnapshot document) {
              ImageFromDB tempImg = new ImageFromDB(
                  document['photographerName'],
                  document['imgUrl'],
                  document['downloadUrl'],
                  document['totalVotes'],
                  document['dateTaken']);

              return tempImg;
            }).toList();
            imgList.sort((a, b) =>
                a.totalVotes.compareTo(b.totalVotes)); //sort list by the votes
            imgList = imgList.reversed
                .toList(); //thanks to dart the lists sort in the wrong order so we need to reverse the final one
            for (int i = 0; i < imgList.length; i++) {
              //make an image card from each object in imglist and add it to the list
              imgCardList.add(_cardWithPic(imgList[i]));
            }

            return Column(
              children: imgCardList, //return the updated and sorted imagecards
            );
            break;
        }
      },
    );
  }

  // Future<String> _getImageDownloadURL(String imageName) async {
  //   //get the download url for the image
  //   var firebaseInstanceReference =
  //       FirebaseStorage.instance.ref().child(imageName);

  //   String tempDBImageUrl = await firebaseInstanceReference.getDownloadURL();

  //   return tempDBImageUrl;
  // }
  _createImagePopUpDialog(BuildContext context, ImageFromDB img) async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Anna ääni'),
          content: SingleChildScrollView(
            child: ButtonBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(
                  child:
                      Text('Joo', style: Theme.of(context).textTheme.body1),
                  onPressed: () {
                    giveVoteToImage(img);
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
          ),
        );
      },
    );
  }

  _cardWithPic(ImageFromDB dbImage) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(
              width: Global.SCREENWIDTH * 0.9,
              child: (dbImage.downloadUrl == null || dbImage.downloadUrl == "")
                  ? CircularProgressIndicator()
                  : Image.network(dbImage.downloadUrl),
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
                            dbImage.photographerName,
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
                          dbImage.totalVotes.toString(),
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
                      onPressed: () {
                        _createImagePopUpDialog(context, dbImage);
                      },
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

  void giveVoteToImage(ImageFromDB img) async {
    //give one vote to image in database
    String today = DateFormat("dd-MM-yyyy")
        .format(DateTime.now())
        .toString(); //today's date

    await Firestore.instance //get the document with the matching parameters
        .collection('imagesForBestImageVoting')
        .where('dateTaken', isEqualTo: today)
        .where('photographerName', isEqualTo: 'name')
        .where('imgUrl', isEqualTo: img.imgUrl)
        .limit(1) //limit documents to 1
        .getDocuments()
        .then((val) {
      Firestore.instance.runTransaction((transaction) async {
        //update the info in the document in database
        DocumentSnapshot freshSnap = await transaction.get(val.documents[0]
            .reference); //get the reference  to our document we want to update
        await transaction.update(freshSnap.reference, {
          'totalVotes': freshSnap['totalVotes'] +
              1, //plus one to the totalVotes in database
        });
      });
    });
  }
}
