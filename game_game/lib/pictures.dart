import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_testuu/votePics.dart';
import 'Globals.dart';
import 'votePics.dart';

class Pictures extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new PicturesState();
  }
}

Image nextImage;
String errorMessage = "Image not found";
int imageIndex = 0;
var votes = new List<dynamic>();
var newVotes = new List<dynamic>();
List<Image> allImages = new List<Image>();
List<Widget> imagesWidget = new List<Widget>();
bool firstTime = true;
bool voteButtonsEnabled = true;

class PicturesState extends State<Pictures> {
  @override
  Widget build(BuildContext context) {
    if (firstTime) {
      GetAllImages();
      firstTime = false;
    }

    // TODO: implement build
    return new WillPopScope(
        child: Scaffold(
            body: new ListView(
        children: <Widget>[
        new Column(
          children: <Widget>[
                  //nextImage == null ? Text(errorMessage) : (nextImage),
            Column(
              children: imagesWidget,
            ),
            //nextImage != null ? Text("I like it ;)") : Text(""),
            new Text("Image " +
                imageIndex.toString() +
                " / " +
                storageSize.toString() +
                "\n"),

            new MaterialButton(
              padding: EdgeInsets.all(10),
              minWidth: 100,
              height: 50,
              color: Global.buttonColors,
              onPressed: () {
                getTheWinner();
              },
              child: new Text(
                "Laske äänet",
                style: new TextStyle(fontSize: 100 / 7, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    )));
  }

  void GetAllImages() async {
    print("GET ALL IMAGES IMGVOTES LENGTIH: " +
        ImageVotes.instance.votes.length.toString());
    while (imageIndex < ImageVotes.instance.votes.length) {
      print("I do not like it. Next image index: " + (imageIndex).toString());

      final ref = FirebaseStorage.instance.ref().child(imageIndex.toString());

      var url = await ref.getDownloadURL();

      Image newImage = Image.network(url);
      allImages.add(newImage);
      print(Image.network(url));

      imageIndex++;
      setState(() {
        errorMessage = url;
        nextImage = newImage;
      });
    }
    ShowList();
  }

  void ShowList() {
    imagesWidget.clear();
    if (ImageVotes.instance.votes.length <= 0) {
      imagesWidget.add(Text("Ei äänestystä meneillään."));
    } else {
      List<Widget> listOfImages = new List<Widget>();
      for (int i = 0; i < ImageVotes.instance.votes.length; i++) {
        listOfImages.add(
          Card(
              child: Column(
            children: <Widget>[
              ListTile(
                title: SizedBox(
                  width: Global.SCREENWIDTH * 0.9,
                  child: allImages[i],
                ),
              ),
              Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              voteButtonsEnabled == true
                  ? new IconButton(
                      icon: Icon(Icons.mood),
                      iconSize: 70.0,
                      color: Colors.green,
                      highlightColor: Colors.green,
                      splashColor: Colors.green,
                      onPressed: () {
                        like();
                      },
                    )
                  : new IconButton(
                      icon: Icon(Icons.mood),
                      iconSize: 70.0,
                      color: Colors.black26),

              //SizedBox(width: Global.SCREENWIDTH),
              voteButtonsEnabled == true
                  ? new IconButton(
                      icon: Icon(Icons.mood_bad),
                      iconSize: 70.0,
                      color: Colors.red,
                      highlightColor: Colors.red,
                      splashColor: Colors.red,
                      onPressed: () {
                        notLike();
                      },
                    )
                  : new IconButton(
                      icon: Icon(Icons.mood_bad),
                      iconSize: 70.0,
                      color: Colors.black26,
                    ),
            ],
          ),
            ],
          )),
        );
      }
      imagesWidget = listOfImages;
      print("LENGTH OF IMAGESWIDGET!!: " + imagesWidget.length.toString());
      setState(() {});
    }
  }

  void like() async {
    voteButtonsEnabled = false;
    print("I like it");

    var docRef = Firestore.instance
        .collection("variables")
        .document("7nqCGxfYuNlmfhAwMoAp");
    ImageVotes.instance.votes[imageIndex] += 1;

    await docRef.updateData({'votes': ImageVotes.instance.votes});

    setState(() {});
  }

  Future notLike() async {
    if (imageIndex <= ImageVotes.instance.votes.length) {
      print("I do not like it. Next image index: " + (imageIndex).toString());

      final ref = FirebaseStorage.instance.ref().child(imageIndex.toString());

      imageIndex++;

      var url = await ref.getDownloadURL();

      Image newImage = Image.network(url);
      print(Image.network(url));

      setState(() {
        errorMessage = url;
        nextImage = newImage;
      });
    } else {
      setState(() {
        print("Yli meni");
        imageIndex = 0;
      });
    }
  }

  void getTheWinner() async {
    newVotes = [1, 2, 2, 3, 4, 5, 2];
    int numberOfbestImages = 0;
    int winnersID = 2;
    //var docRef = await Firestore.instance.collection("variables").document("7nqCGxfYuNlmfhAwMoAp");

    DocumentReference docRef = await Firestore.instance
        .collection('variables')
        .document("7nqCGxfYuNlmfhAwMoAp");

    var jsonList;
    docRef.get().then((DocumentSnapshot ds) {
      //votes = ds['votes'];

      jsonList = ImageVotes.fromJson(ds.data);
      ImageVotes.instance.votes = jsonList;
      print("imgVotes: " + ImageVotes.instance.votes.toString());

      print("Winner is number " +
          winnersID.toString() +
          " votes: " +
          numberOfbestImages.toString());
      //print(countArray(votes, 6));
      //print(newVotes.toString() + " " + countArray(newVotes, 2).toString());
    });

    for (int i = 0; i < ImageVotes.instance.votes.length; i++) {
      //print("JEE: " + ImageVotes.instance.votes[i]);
    }
  }

  //int countArray(List<dynamic> arr, int value){
  //  if(arr.length == 1){
  //    if(arr[0] == value) return 1;
  //    else return 0;
  //  }
  //  else{
  //    arr.removeLast();
  //    if(2 == value) return 1 + countArray(arr, value);
  //    else return 0 + countArray(arr, value);
  //  }
  //}

  int countArray(List<dynamic> arr) {
    int x = 0;
    int n = 0;
    int first;
    first = arr.first;

    for (int i = 0; i < arr.length; i++) {
      if (arr[0] == first) x++;

      arr.removeAt(0);

      if (x > n) n = x;
    }

    return n;
  }
}
