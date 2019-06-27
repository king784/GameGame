
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'pictures.dart';
import 'Globals.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class VotePics extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      theme: ThemeData(fontFamily: "Arial"),
      home: _VotePics(),
    );
  }
}

int storageSize = 0;

class _VotePics extends StatefulWidget {
  createState() => VoteState();
}

class VoteState extends State<_VotePics>{

  String infoText = "No image selected";
  bool imageReady = false;

  @override
  Widget build(BuildContext context) {

    //uploadPhoto();
    loadStorageFiles();

    return Scaffold(
      appBar: new AppBar(
        title: new Text("Photos lol"),
        backgroundColor: Colors.green,
      ),
          body: new Container(
             decoration: new BoxDecoration(
              image: new DecorationImage(
                  image: new AssetImage("images/backGround.jpg"),
                  fit: BoxFit.fill,
                  colorFilter: new ColorFilter.mode(
                      Colors.white.withOpacity(0.15), BlendMode.dstATop)
                //fit: BoxFit.cover,
              ),
            ),

            alignment: Alignment.topCenter,
            child: new Column(
              children: <Widget>[

                  new MaterialButton(
                      padding: EdgeInsets.all(10),
                      minWidth: 100,
                      height: 50,
                      color: Global.buttonColors,
                      onPressed: () {
                        choosePhoto();
                      },
                      child: new Text("Lisää kuva",
                        style: new TextStyle(
                            fontSize: 100 / 7,
                            color: Colors.white
                        ),
                      ),
                    ),

                    SizedBox(height: 50),
              
                _image == null ? Text("") : Image.file(_image,
                  width: 200,
                ),

                    SizedBox(height: 50),
                
                  imageReady == false ? Text("") :new MaterialButton(
                      padding: EdgeInsets.all(10),
                      minWidth: 100,
                      height: 50,
                      color: Global.buttonColors,
                      onPressed: () {
                        uploadPhoto(context);
                      },
                      child: new Text("Lähetä kuva",
                        style: new TextStyle(
                            fontSize: 100 / 7,
                            color: Colors.white
                        ),
                      ),
                    ),


                  new MaterialButton(
                      padding: EdgeInsets.all(10),
                      minWidth: 100,
                      height: 50,
                      color: Global.buttonColors,
                      onPressed: () {
                        Navigator.push(context, new MaterialPageRoute(builder: (context) => new Pictures()));
                      },
                      child: new Text("Selaa kuvia",
                        style: new TextStyle(
                            fontSize: 100 / 7,
                            color: Colors.white
                        ),
                      ),
                    ),

                    Text(infoText),

                    new MaterialButton(
                      padding: EdgeInsets.all(10),
                      minWidth: 100,
                      height: 50,
                      color: Colors.red,
                      onPressed: () {
                        resetImages();
                      },
                      child: new Text("Nollaa",
                        style: new TextStyle(
                            fontSize: 100 / 7,
                            color: Colors.white
                        ),
                      ),
                    ),

            ],

            ),
            
          ),


      );
  }
  
  File _image;
 // final SnackBar snackBar(content: Text("asd"));

  Future choosePhoto() async{
    
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

  Future uploadPhoto(BuildContext context) async{

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
        infoText = "Kuvaa lähetetään. Odota hetki.\nKuvia tietokannassa: " +  tmpString; 
      });

    await Firestore.instance.collection("variables").document("7nqCGxfYuNlmfhAwMoAp").updateData({
      'votes': ImageVotes.instance.votes
    });

    String fileName = storageSize.toString();

    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
    //_image.rename(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    //storageSize++;
    
    setState(() {
      print("File named: " + fileName + " uploaded");
      Navigator.push(context, new MaterialPageRoute(builder: (context) => new Pictures()));
      //Scaffold.of(context).showSnackBar(snackbar);
    });
  }

  void resetImages(){
    voteButtonsEnabled = true;
    setState(() {
      infoText = "Nollataan";
      storageSize = 0;
      imageIndex = 1;
      infoText = "Nollattu";
    });
  }

  void loadStorageFiles() async{
    var docRef = await Firestore.instance.collection("variables").document("7nqCGxfYuNlmfhAwMoAp");

    // docRef.get().then((DocumentSnapshot ds){
    //   //print(ds['numOfImages'].toString());
    //   //fileName = ds['numOfImages'].toString();
    //   //storageSize = ds['numOfImages'];
    //   //print(fileName);
    // });
    var jsonList;
    docRef.get().then((DocumentSnapshot ds){
        jsonList = ImageVotes.fromJson(ds.data);
        
        print("imgVotes: " + jsonList.toString());
    });
  }
}