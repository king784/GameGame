import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'Globals.dart';


void main() => runApp(AdminMain());


class AdminMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Arial',
      ),
      home: Admin(),
    );
  }
}

class Admin extends StatefulWidget {
  createState() => AdminState();
}

class AdminState extends State<Admin> {

  String timeText = "";
  DateTime votingEndTime = null;
  Timer customTimer;

  @override
    Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        title: (
          Text('Add players')),
          backgroundColor: Global.titleBarColor,
      ),
      body:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: const Text("Aloita 3 minuutin ajastin"),
              onPressed: (){
                setVotingStartTime();
                //getVotingStartTime();
                //print(DateTime.now().toString());
                setState(() {
                  
                });
              },
            ),
            RaisedButton(
              child: const Text("Kerro paljon aikaa"),
              onPressed: (){
                getVotingStartTime();
                //print(DateTime.now().toString());
                setState(() {
                  
                });
              },
            ),
            Text(
              timeText
            ),
            RaisedButton(
              child: const Text("Lisää pelaaja"),
              onPressed: (){
                Player pelaaja = new Player(12, 'Testuu', 'Jäbä', 'BC Nokia');
                CollectionReference dbCollectionRef = Firestore.instance.collection('players');
                Firestore.instance.runTransaction((Transaction tx) async {
                  var result = await dbCollectionRef.add(pelaaja.toJson());
                });
                setState(() {
                  
                });
              },
            ),
            Text("Pelaajat: "),
            StreamBuilder(
            stream: Firestore.instance.collection('players').snapshots(),
            builder: (context, snapshot){
              if(!snapshot.hasData)
              {
                print("joo");
                return new CircularProgressIndicator();
              }
              else
              {
                print(snapshot.data);
                return new ListView.builder(
                  shrinkWrap: true,
                  itemExtent: 80.0,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) =>
                    buildListItem(context, snapshot.data.documents[index]),
                );
              }
            }),
          ],
        )
      );
    }

    void getVotingStartTime() async {
      DocumentReference gamesRef = await Firestore.instance.collection('games').document('iSFhdMRlPSQWh3879pXL');
      DateTime convertedTime;
      gamesRef.get().then((DocumentSnapshot ds){
        convertedTime = DateTime.fromMillisecondsSinceEpoch(ds['VotingStartTime'].millisecondsSinceEpoch);
        print(convertedTime.toString());
        //timeText = convertedTime.toString();
        votingEndTime = convertedTime.add(Duration(minutes: 3));
        timeText = votingEndTime.second.toString();
        customTimer = Timer.periodic(Duration(seconds: 1), (Timer t) => updateTimeLeft());
      }); 
    }

    void setVotingStartTime() async {
      DocumentReference gamesRef = await Firestore.instance.collection('games').document('iSFhdMRlPSQWh3879pXL');
      DateTime currentTime = DateTime.now();
      FieldValue.serverTimestamp();
      gamesRef.setData({
        "VotingStartTime":currentTime
      });
    }

    void updateTimeLeft(){
      Duration difference = votingEndTime.difference(DateTime.now());   
      //timeText = new DateFormat.format(votingEndTime.difference(DateTime.now()));
      //timeText = DateFormat.MINUTE_SECOND;
      //timeText = (votingEndTime.minute - DateTime.now().minute).toString() + ':' + (votingEndTime.second - DateTime.now().second).toString();
      String seconds = ((difference.inMinutes * 60 - difference.inSeconds) * -1).toString();
      timeText = difference.inMinutes.toString() + ":" + seconds;
      print(timeText);
      setState(() {});
    }

    Widget buildListItem(BuildContext context, DocumentSnapshot document)
    {
      return ListTile(
        title: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                document['firstName'] + ' ' + document['lastName'],
                style: Theme.of(context).textTheme.display1,
              ),
            ),
          ],
        ),
      );
    }
}