import 'dart:io';
import 'dart:typed_data';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_testuu/Themes/MasterTheme.dart';
import 'package:flutter_testuu/mainMenu.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:flutter_testuu/votePics.dart';
import 'Globals.dart';
import 'votePics.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:device_info/device_info.dart';

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
List<CachedNetworkImage> allImages = new List<CachedNetworkImage>();
CachedNetworkImage bestImage;
List<Widget> imagesWidget = new List<Widget>();
bool firstTime = true;
bool voteButtonsEnabled = true;

String infoText = "";
bool imageReady = false;
File _image;
int winnersHashCode;
int saveHashCode;

bool imagesLoaded = false;
bool loadingImages = false;
bool addInActive = false;
bool ableToSendImage = true;
bool disableSendButton = false;

class PicturesState extends State<Pictures> {

  List<Widget> thisIsAList = new List<Widget>();

  @override
  Widget build(BuildContext context){
    if (firstTime) {

      ImageVotes imgVotes = ImageVotes.instance;
      ImageVotes.instance.votes = new List<int>();

      DeviceHashCodes.instance.hCodes = new List<int>();
    
      //GetAllImages();
      firstTime = false;
      thisIsAList.add(Container());

      setState(() {
        loadStorageFiles();
      });

    }

    // TODO: implement build
    return new WillPopScope(
        child: Theme(
          data: MasterTheme.mainTheme,
          child: Scaffold(
            body: new ListView(
        children: <Widget>[
        new Column(
          children: <Widget>[

            _image == null || ableToSendImage == false ? SizedBox.shrink() : Image.file(_image,
                  width: 200,
                ),

                    //SizedBox(height: 50),
                
                  imageReady == false || ableToSendImage == false ? SizedBox.shrink() :new MaterialButton(
                      padding: EdgeInsets.all(10),
                      minWidth: 100,
                      height: 50,
                      color: Global.buttonColors,
                      onPressed: () {
                        uploadPhoto(context);
                        //_image = null;
                        //ableToSendImage = false;
                      },
                      child: new Text("Lähetä kuva",
                        style: new TextStyle(
                            fontSize: 100 / 7,
                            color: Colors.white
                        ),
                      ),
                    ),

                  new Text(infoText),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                  new MaterialButton(
                      padding: EdgeInsets.all(10),
                      minWidth: 100,
                      height: 50,
                      color: disableSendButton == false ? Global.buttonColors : Global.buttonColors.withOpacity(0.5),
                      onPressed: () {setState(() {
                        _image = null;
                      });

                      if(!disableSendButton){
                        if(!addInActive)
                          addInActive = true;
                        else
                          choosePhoto(false);
                          //addInActive == false ? addInActive = true : choosePhoto(false);
                        }
                      },

                      child: addInActive == false ? 
                      new Text("Lisää kuva",
                        style: new TextStyle(
                            fontSize: 100 / 7,
                            color: Colors.white
                        ),
                      ) :
                      new Text("Kamera",
                        style: new TextStyle(
                            fontSize: 100 / 7,
                            color: Colors.white
                        ),
                      )

                    ),

                  new SizedBox(
                      width: 100,
                  ),

                  new MaterialButton(
                      padding: EdgeInsets.all(10),
                      minWidth: 100,
                      height: 50,
                      color: Global.buttonColors,
                      onPressed:
                        addInActive == false ? () {
                          loadingImages = true;
                          setState(() {
                            //imageIndex = 0;
                            loadStorageFiles();
                          });
                      }: (){
                        choosePhoto(true);
                      },
                      child: addInActive == false ? 
                      new Text("Päivitä",
                        style: new TextStyle(
                            fontSize: 100 / 7,
                            color: Colors.white
                        ),
                      ) :
                      new Text("Galleria",
                        style: new TextStyle(
                            fontSize: 100 / 7,
                            color: Colors.white
                        ),
                      )
                    ),

                  new SizedBox(
                      height: 100,
                  ),

              ],

            ),


                  //nextImage == null ? Text(errorMessage) : (nextImage),
            Column(
              children: imagesLoaded == true ? imagesWidget : thisIsAList,
            ),
            //nextImage != null ? Text("I like it ;)") : Text(""),

            loadingImages == true ? Text("Ladataan kuvia. Odota hetki") : Text(""),

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
                checkDevice();
                  getTheWinner();
              },
              child: new Text(
                "Laske äänet",
                style: new TextStyle(fontSize: 100 / 7, color: Colors.white),
              ),
            ),

              Align(
                alignment: Alignment.bottomLeft,
                child: RaisedButton(
              onPressed: (){
               Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainMenu()),
                );
              },
                  child: Row(
                    children: <Widget>[
                      Icon(FontAwesomeIcons.arrowLeft),
                      Text("Palaa takaisin"),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    ))) );
  }

  Future GetAllImages() async {
    print("GET ALL IMAGES IMGVOTES LENGTIH: " +
        ImageVotes.instance.votes.length.toString());
        
    while (imageIndex < ImageVotes.instance.votes.length) {

      final ref = FirebaseStorage.instance.ref().child(imageIndex.toString());

      var url = await ref.getDownloadURL();

      print("Image.network(url): " + Image.network(url).toString());
      //Image newImage = Image.network(url);
      CachedNetworkImage newImage = CachedNetworkImage(
        imageUrl: url,
        placeholder: (context, url) => new CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
      allImages.add(newImage);

      imageIndex++;
      setState(() {
        errorMessage = url;
        nextImage = newImage;
      });
    }
    print("GetAllImages Done");
    ShowList();
  }

  double realImageHeight(){
    //print("");
    return Global.SCREENWIDTH;
  }

  void ShowList() {
    loadingImages = false;
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
                  child: allImages[i],
                  height: realImageHeight(),
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
                        print(i);
                        likelike(i);
                      },
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Icon(FontAwesomeIcons.plus)
                          ),
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Text("Vote")
                          ),
                        ],
                      ),
                    ),
                  )
                  : new Padding(
                    padding: EdgeInsets.all(10),
                    child: MaterialButton(
                      color: Colors.black26,
                      child: Row(
                        children: <Widget>[
                           Padding(
                            padding: EdgeInsets.all(5),
                            child: Icon(FontAwesomeIcons.plus)
                          ),
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Text("Vote")
                          ),
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
                        notLike(i);
                      },
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Icon(FontAwesomeIcons.minus)
                          ),
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Text("Unvote")
                          ),
                        ],
                      ),
                    ),
                  )
                  : new MaterialButton(
                      color: Colors.black26,
                      child: Row(
                        children: <Widget>[
                           Padding(
                            padding: EdgeInsets.all(5),
                            child: Icon(FontAwesomeIcons.plus)
                          ),
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Text("Unvote")
                          ),
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

  Future choosePhoto(bool fromGallery) async{
    addInActive = false;
    File image;
    
    if(fromGallery)
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    else
      image = await ImagePicker.pickImage(source: ImageSource.camera);

    print(image.path);

    setState(() {
      infoText = "Kuva valittu";
      //teksti = "Image is: $_image";
      _image = image;
      imageReady = true;
      ableToSendImage = true;
    });
  }

  Future uploadPhoto(BuildContext context) async{
    
    disableSendButton = true;
    loadStorageFiles();
    String tmpString = "";
    int temp;

    if(ImageVotes.instance.votes == null)
    {
      tmpString = "0";
    }
    else
    {
      ImageVotes.instance.votes.add(0);
      tmpString = ImageVotes.instance.votes.length.toString();
    }

      setState(() {
        infoText = "Kuvaa lähetetään. Odota hetki"; 
      });

    await Firestore.instance.collection("variables").document("7nqCGxfYuNlmfhAwMoAp").updateData({
      'votes': ImageVotes.instance.votes
    });


    String fileName = (ImageVotes.instance.votes.length-1).toString(); // storageSize.toString();

    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;


    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    saveHashCode = androidInfo.hashCode;

    DeviceHashCodes.instance.hCodes.add(saveHashCode);
    temp = DeviceHashCodes.instance.hCodes.length;

    newHashList = DeviceHashCodes.instance.hCodes + saveHashCode;

    await Firestore.instance.collection("variables").document("goPGa5dT3ouzNOdgigO2").updateData({
      'hashCodes' : DeviceHashCodes.instance.hCodes
    });

    setState(() {
      print("File named: " + fileName + " uploaded");
      Navigator.push(context, new MaterialPageRoute(builder: (context) => new Pictures()));
      //Scaffold.of(context).showSnackBar(snackbar);
      infoText = "Kuva lähetetty";
      ableToSendImage = false;
    });

    //_image = null;
  }

  void loadStorageFiles() async{
    var docRef = await Firestore.instance.collection("variables").document("7nqCGxfYuNlmfhAwMoAp");

    // docRef.get().then((DocumentSnapshot ds){
    //   //print(ds['numOfImages'].toString());
    //   //fileName = ds['numOfImages'].toString();
    //   //storageSize = ds['numOfImages'];
    //   //print(fileName);
    // });


    //TODO Empty check
    var jsonList;
    docRef.get().then((DocumentSnapshot ds){
      jsonList = ImageVotes.fromJson(ds.data);

    });

    //var jsonHashList;
    //docRef.get().then((DocumentSnapshot ds){
    //  jsonHashList = DeviceHashCodes.fromJson(ds.data);
//
    //});

      GetAllImages();
  }

  void likelike(int i) async {
    //voteButtonsEnabled = false;
    print("I like it");

    var docRef = Firestore.instance
        .collection("variables")
        .document("7nqCGxfYuNlmfhAwMoAp");
    ImageVotes.instance.votes[i] += 1;
    print(i);

    await docRef.updateData({'votes': ImageVotes.instance.votes});

    setState(() {});
  }

  Future notLike(int i) async {
    print("I dont like it");

    var docRef = Firestore.instance
        .collection("variables")
        .document("7nqCGxfYuNlmfhAwMoAp");
    ImageVotes.instance.votes[i] -= 1;
    print(i);

    await docRef.updateData({'votes': ImageVotes.instance.votes});

    setState(() {});
  }

  void getTheWinner() async {
    DocumentReference docRef = await Firestore.instance
        .collection('variables')
        .document("7nqCGxfYuNlmfhAwMoAp");

    var jsonList;
    docRef.get().then((DocumentSnapshot ds) {
      jsonList = ImageVotes.fromJson(ds.data);
    });

    var highestIndex = ImageVotes.instance.votes.reduce(max);
    var indexOfHighest = ImageVotes.instance.votes.indexOf(highestIndex);
    print(ImageVotes.instance.votes.toString() + " " + ImageVotes.instance.votes.reduce(max).toString());
    print(indexOfHighest);

    setState(() {
      infoText = "\nVoittaja on: " + indexOfHighest.toString() + ". \nÄänillä " + highestIndex.toString(); 

      //imageIndex = 0;
      bestImage = allImages[indexOfHighest];

      Navigator.push(context, MaterialPageRoute(builder: (context) => WinnerPicture()),);

    });
  }

    void checkDevice() async{
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print('Model: ${androidInfo.model} Id: ${androidInfo.id} HashCode: ${androidInfo.hashCode} '); // :D
  }
}



class WinnerPicture extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ShowWinner();
  }
}

class ShowWinner extends State<WinnerPicture> {

  @override
  Widget build(BuildContext context){

    print(saveHashCode);

    // TODO: implement build
    return new WillPopScope(
        child: Theme(
          data: MasterTheme.mainTheme,
          child: Scaffold(
            body: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("\n\nParhaimmaksi kuvaksi on valittu\n"),
                Card(
                  child: Padding(
                    
                    padding: const EdgeInsets.fromLTRB(100, 10, 100, 10),
                    child: bestImage,
                  )
                  
                  //width: Global.SCREENWIDTH * 2,
                ),

              ],
            )
        )
      )
    );
  }
}
