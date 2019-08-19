import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_testuu/Globals.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
            return Column(
              children: snapshot.data.documents
                  .map<Widget>((DocumentSnapshot document) {
                ImageFromDB tempImg = new ImageFromDB(
                    document['photographerName'],
                    document['imgUrl'],
                    document['downloadUrl'],
                    document['totalVotes']);

                return _cardWithPic(tempImg);
              }).toList(),
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
}
