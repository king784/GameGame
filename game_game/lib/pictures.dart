import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_testuu/votePics.dart';
import 'Globals.dart';

class Pictures extends StatefulWidget{
  @override
  State<StatefulWidget> createState(){
    return new PicturesState();
  }
}

Image nextImage;
String errorMessage = "Image not found";
int imageIndex = 0; 

class PicturesState extends State<Pictures> {
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return new WillPopScope(
        child: Scaffold(
          body: new Container(
            alignment: Alignment.center,
            child: new Column(
              children: <Widget>[

                SizedBox(
                  height: Global.SCREENHEIGHT / 10,
                  ),

                new Container(
                  child: nextImage == null ? Text(errorMessage) : (nextImage),
                  width: Global.SCREENWIDTH * 2,
                ),


                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                

                new IconButton(
                  icon: Icon(Icons.mood),
                  iconSize: 70.0,

                  color: Colors.green,
                  highlightColor: Colors.green,
                  splashColor: Colors.green,

                  onPressed: () {like();},

                ),

                //SizedBox(width: Global.SCREENWIDTH),
              
                new IconButton(
                  icon: Icon(Icons.mood_bad),
                  iconSize: 70.0,

                  color: Colors.red,
                  highlightColor: Colors.red,
                  splashColor: Colors.red,

                  onPressed: () {notLike();},

                ),
                
                ],
                
                
                )

                //nextImage != null ? Text("I like it ;)") : Text(""),

              ],
            ),
          )
        )
    );
  }

  void like(){
    print("I like it");
    
    setState(() {  
      imageIndex = 0;
    });
  }

  Future notLike() async{
    print("I do not like it");

    //List<String> refList = ["Larry.png", "IMG-20190611-WA0005.jpg", "IMG_20190614_144257.jpg", "IMG_20190604_110854~2.jpg"];

    //final ref = FirebaseStorage.instance.ref().child("Larry.png");
    final ref = FirebaseStorage.instance.ref().child(imageIndex.toString());

    imageIndex++;

    var url = await ref.getDownloadURL();
    print(url);

    Image newImage = Image.network(url);

    setState(() {
      errorMessage = url;
      nextImage = newImage;
    });
     return new Future.delayed(const Duration(milliseconds: 1), () => "10");
  }

}