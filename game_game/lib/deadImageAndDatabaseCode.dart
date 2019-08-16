import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'imageFromDB.dart';

class dontUseMe {
//only for notes

  List<ImageFromDB> allimages =
      new List<ImageFromDB>(); //holds the final list of images
  List<Card> imgCards = new List<Card>();
  bool imagesLoaded = false;
  bool firstRun = true;

  Future<void> makeWidgetListFromImagesList() async {
    imgCards.clear();

    String tempDBImageUrl = "";

    for (int i = 0; i < allimages.length; i++) {
      var allimages;
      var firebaseInstanceReference =
          FirebaseStorage.instance.ref().child(allimages[i].imgUrl);

      tempDBImageUrl = await firebaseInstanceReference.getDownloadURL();
      allimages[i].imgUrl =
          tempDBImageUrl; //make the download url be the img url so that the images show up
      //print('tempDbImageUrl: ' + tempDBImageUrl);

    }
  }

  void updateImages() async {
    ImageFromDB tempImg;

    //listen to changes and update images after first time
    var res = await Firestore.instance
        .collection('imagesForBestImageVoting')
        .snapshots();

    res.listen((data) {
      print("Listening to db for image changes");

      //get the documents from firestore and make a new tempimg from each changed document
      data.documentChanges.forEach((change) {
        tempImg = new ImageFromDB(
            change.document['photographerName'],
            change.document['downloadUrl'],
            change.document['imgUrl'],
            change.document['totalVotes']);

        //see if there is an old image with same path and photographer in  the allimagews list and save the index
        int queryIndex = allimages.indexWhere((img) =>
            img.photographerName == tempImg.photographerName &&
            img.imgUrl == tempImg.imgUrl);
        if (queryIndex >= 0) {
          //if an image with same uploader and path/filename was found
          //if the image from db has more votes than the temp image
          if (tempImg.totalVotes > allimages[queryIndex].totalVotes) {
            //just to make it clear the temp image is the never version of the found image query

            //update the old image
            allimages[queryIndex] = tempImg;
          }
        } else {
          //the same image was not found
          // add the new image to allimages list
          allimages.add(tempImg);
        }
      });
    });
    await _sortImages(allimages);
    await makeWidgetListFromImagesList();
  }

  void loadImagesFromDBFirstTime() async {
    final QuerySnapshot result = await Firestore.instance
        .collection(
            'imagesForBestImageVoting') //get the documents from this collection
        .getDocuments();

    for (int i = 0; i < result.documents.length; i++) {
      //go through all the documents we got from firestore
      allimages.add(new ImageFromDB(
          result.documents[i]['photographerName'],
          result.documents[i]['downloadUrl'],
          result.documents[i]['imgUrl'],
          result.documents[i]['totalVotes']));
      // print('result image url: ' + allimages[i].imgUrl);
      //print(allimages[i].toString());
    }

    await _sortImages(allimages);
    await makeWidgetListFromImagesList();
    firstRun = false;
  }

  Future<void> _sortImages(List<ImageFromDB> imgList) {
    if (imgList != null) {
      imgList.sort((a, b) => a.totalVotes.compareTo(b.totalVotes));
      imgList = imgList.reversed.toList();
      imagesLoaded = true;
    }
  }
}

class _cardWithPic {}
