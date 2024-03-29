import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_testuu/Themes/MasterTheme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'Globals.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Pictures extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new PicturesState();
  }
}

CachedNetworkImage nextImage;
String errorMessage = "Image not found";
int imageIndex = 0;
var votes = new List<dynamic>();
var newVotes = new List<dynamic>();
List<CachedNetworkImage> allImages = new List<CachedNetworkImage>();
List<Widget> imagesWidget = new List<Widget>();
bool firstTime = true;
bool voteButtonsEnabled = true;

String infoText = "No image selected";
bool imageReady = false;
File _image;

bool imagesLoaded = false;

class PicturesState extends State<Pictures> {
  List<Widget> thisIsAList = new List<Widget>();

  @override
  Widget build(BuildContext context) {
    if (firstTime) {
      ImageVotes imgVotes = ImageVotes.instance;
      ImageVotes.instance.votes = new List<int>();
      loadStorageFiles();

      //GetAllImages();
      firstTime = false;
      thisIsAList.add(Container());
    }

    // TODO: implement build
    return new WillPopScope(
        onWillPop: () async => false,
        child: Theme(
            data: MasterTheme.mainTheme,
            child: Scaffold(
                body: new ListView(
              children: <Widget>[
                new Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topCenter,
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                            child: FloatingActionButton(
                                heroTag: 'backBtn2',
                                child: Icon(
                                  FontAwesomeIcons.arrowLeft,
                                  color: MasterTheme.accentColour,
                                  size: 40,
                                ),
                                backgroundColor: Colors.transparent,
                                onPressed: () =>{},
                                elevation: 0),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                'Kuvan äänestys',
                                textAlign: TextAlign.right,
                                style: Theme.of(context).textTheme.title,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    _image == null
                        ? SizedBox.shrink()
                        : Image.file(
                            _image,
                            width: 200,
                          ),

                    //SizedBox(height: 50),

                    imageReady == false
                        ? SizedBox.shrink()
                        : new MaterialButton(
                            padding: EdgeInsets.all(10),
                            minWidth: 100,
                            height: 50,
                            color: Global.buttonColors,
                            onPressed: () {
                              uploadPhoto(context);
                            },
                            child: new Text(
                              "Lähetä kuva",
                              style: new TextStyle(
                                  fontSize: 100 / 7, color: Colors.white),
                            ),
                          ),

                    new MaterialButton(
                      padding: EdgeInsets.all(10),
                      minWidth: 100,
                      height: 50,
                      color: Global.buttonColors,
                      onPressed: () {
                        choosePhoto();
                      },
                      child: new Text(
                        "Lisää kuva",
                        style: new TextStyle(
                            fontSize: 100 / 7, color: Colors.white),
                      ),
                    ),
                    //nextImage == null ? Text(errorMessage) : (nextImage),
                    Column(
                      children:
                          imagesLoaded == true ? imagesWidget : thisIsAList,
                    ),
                    //nextImage != null ? Text("I like it ;)") : Text(""),
                    new Text("Image " +
                        imageIndex.toString() +
                        " / " +
                        ImageVotes.instance.votes.length.toString() +
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
                        style: new TextStyle(
                            fontSize: 100 / 7, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ))));
  }

  Future GetAllImages() async {
    print("GET ALL IMAGES IMGVOTES LENGTIH: " +
        ImageVotes.instance.votes.length.toString());
    while (imageIndex < ImageVotes.instance.votes.length) {
      print("I do not like it. Next image index: " + (imageIndex).toString());

      final ref = FirebaseStorage.instance.ref().child(imageIndex.toString());

      var url = await ref.getDownloadURL();

      //Image newImage = Image.network(url);
      CachedNetworkImage newImage = CachedNetworkImage(
        imageUrl: url,
        placeholder: (context, url) => new CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
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
                      ? new Padding(
                          padding: EdgeInsets.all(10),
                          child: MaterialButton(
                            color: Colors.green,
                            highlightColor: Colors.green,
                            splashColor: Colors.green,
                            onPressed: () {
                              like();
                            },
                            child: Row(
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Icon(FontAwesomeIcons.plus)),
                                Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text("Vote")),
                              ],
                            ),
                          ),
                        )
                      : new Padding(
                          padding: EdgeInsets.all(10),
                          child: MaterialButton(
                            onPressed: () => {},
                            color: Colors.black26,
                            child: Row(
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Icon(FontAwesomeIcons.plus)),
                                Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text("Vote")),
                              ],
                            ),
                          ),
                        ),

                  //SizedBox(width: Global.SCREENWIDTH),
                  voteButtonsEnabled == true
                      ? new Padding(
                          padding: EdgeInsets.all(10),
                          child: MaterialButton(
                            color: Colors.red,
                            highlightColor: Colors.red,
                            splashColor: Colors.red,
                            onPressed: () {
                              notLike();
                            },
                            child: Row(
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Icon(FontAwesomeIcons.minus)),
                                Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text("Unvote")),
                              ],
                            ),
                          ),
                        )
                      : new MaterialButton(
                          onPressed: () => {},
                          color: Colors.black26,
                          child: Row(
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Icon(FontAwesomeIcons.plus)),
                              Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text("Unvote")),
                            ],
                          ),
                        ),
                ],
              ),
            ],
          )),
        );
      }
      imagesWidget = listOfImages;
      imagesLoaded = true;
      print("LENGTH OF IMAGESWIDGET!!: " + imagesWidget.length.toString());
      setState(() {});
    }
  }

  Future choosePhoto() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    //File image = await ImagePicker.pickImage(source: ImageSource.camera);

    print(image.path);

    setState(() {
      infoText = "Kuva valittu";
      //teksti = "Image is: $_image";
      _image = image;
      imageReady = true;
    });
  }

  Future uploadPhoto(BuildContext context) async {
    //var docRef = await Firestore.instance.collection("variables").document("7nqCGxfYuNlmfhAwMoAp");
//
    //docRef.get().then((DocumentSnapshot ds){
    //  print(ds['numOfImages'].toString());
    //  //fileName = ds['numOfImages'].toString();
    //  storageSize = ds['numOfImages'];
    //  //print(fileName);
//
    //  setState(() {
    //    infoText = "Kuvaa lähetetään. Odota hetki.\nKuvia tietokannassa: " + storageSize.toString();
    //  });
//
    //});

    loadStorageFiles();
    String tmpString = "";
    if (ImageVotes.instance.votes == null) {
      tmpString = "0";
    } else {
      ImageVotes.instance.votes.add(0);
      tmpString = ImageVotes.instance.votes.length.toString();
    }

    setState(() {
      infoText =
          "Kuvaa lähetetään. Odota hetki.\nKuvia tietokannassa: " + tmpString;
    });

    await Firestore.instance
        .collection("variables")
        .document("7nqCGxfYuNlmfhAwMoAp")
        .updateData({'votes': ImageVotes.instance.votes});

    String fileName = (ImageVotes.instance.votes.length - 1)
        .toString(); // storageSize.toString();

    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    //_image.rename(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    //storageSize++;

    setState(() {
      print("File named: " + fileName + " uploaded");
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => new Pictures()));
      //Scaffold.of(context).showSnackBar(snackbar);
    });
  }

  void resetImages() {
    voteButtonsEnabled = true;
    setState(() {
      infoText = "Nollataan";
      imageIndex = 1;
      infoText = "Nollattu";
    });
  }

  void loadStorageFiles() async {
    var docRef = await Firestore.instance
        .collection("variables")
        .document("7nqCGxfYuNlmfhAwMoAp");

    // docRef.get().then((DocumentSnapshot ds){
    //   //print(ds['numOfImages'].toString());
    //   //fileName = ds['numOfImages'].toString();
    //   //storageSize = ds['numOfImages'];
    //   //print(fileName);
    // });
    var jsonList;
    docRef.get().then((DocumentSnapshot ds) {
      jsonList = ImageVotes.fromJson(ds.data);
      print("imgVotes: " + jsonList.toString());
    });
    imagesLoaded = true;

    GetAllImages();
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
      //   print("I do not like it. Next image index: " + (imageIndex).toString());

      //   final ref = FirebaseStorage.instance.ref().child(imageIndex.toString());

      //   imageIndex++;

      //   var url = await ref.getDownloadURL();

      //   Image newImage = Image.network(url);
      //   print(Image.network(url));

      //   setState(() {
      //     errorMessage = url;
      //     nextImage = newImage;
      //   });
      // } else {
      //   setState(() {
      //     print("Yli meni");
      //     imageIndex = 0;
      //   });
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
