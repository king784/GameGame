import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Globals.dart';

void main() => runApp(PlayerVotingMain());

class PlayerVotingMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Arial',
      ),
      home: PlayerVoting(),
    );
  }
}

class PlayerVoting extends StatefulWidget {
  createState() => PlayerVotingState();
}

class PlayerVotingState extends State<PlayerVoting> {

  @override
    Widget build(BuildContext context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          StreamBuilder(
            stream: Firestore.instance.collection('players').snapshots(),
            builder: (context, snapshot){
              if(!snapshot.hasData)
              {
                const Text('Loading');
              }
              else
              {
                ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index)
                  {
                    DocumentSnapshot mypost = snapshot.data.documents[index];
                    return Column(
                      children: <Widget>[
                        Container(
                          width: Global.SCREENWIDTH,
                          height: 450.0,
                          child: Padding(
                            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Material(
                              color: Colors.white,
                              shadowColor: Color(0x802196F3),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(children: <Widget>[
                                    Container(
                                      width: Global.SCREENWIDTH,
                                      height: 200.0,
                                      child: Text(
                                        '${mypost['firstName']}',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: Global.SCREENWIDTH,
                                      height: 200.0,
                                      child: Text(
                                        '${mypost['lastName']}',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                  ],),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                );
              }
            },
          )
      ],);
    }
}