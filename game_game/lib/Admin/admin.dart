import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_testuu/Admin/AddQuestions.dart';
import 'package:flutter_testuu/route_generator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../Globals.dart';
import '../Navigation.dart';
import '../Themes/MasterTheme.dart';

void main() => runApp(AdminMain());

class AdminMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: MasterTheme.mainTheme,
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

  var usersATM;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    userCounter();
    return WillPopScope(
      onWillPop: () async => false,
      child: Theme(
        data: MasterTheme.mainTheme,
        child: Scaffold(
          body: ListView(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                      child: FloatingActionButton(
                          heroTag: 'backBtn1',
                          child: Icon(
                            FontAwesomeIcons.arrowLeft,
                            color: MasterTheme.accentColour,
                            size: 40,
                          ),
                          backgroundColor: Colors.transparent,
                          onPressed: () => Navigation.openGames(context),
                          elevation: 0),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Pelaajaäänestys',
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.title,
                        ),
                      ),
                    )
                  ],
                ),
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: const Text("Aloita 3 minuutin ajastin"),
                    onPressed: () {
                      setVotingStartTime();
                      //getVotingStartTime();
                      //print(DateTime.now().toString());
                      setState(() {});
                    },
                  ),
                  RaisedButton(
                    child: const Text("Kerro paljon aikaa"),
                    onPressed: () {
                      getVotingStartTime();
                      //print(DateTime.now().toString());
                      setState(() {});
                    },
                  ),
                  RaisedButton(
                    child: const Text("Lisää kysymys"),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddQuestionForm()),);
                      //AddQuestion();
                      //print(DateTime.now().toString());
                      setState(() {});
                    },
                  ),
                  Text(timeText),
                  Text("Kilpoilijoita: " + usersATM),
                ],
              ),
              // ADDING PLAYERS
              // RaisedButton(
              //   child: const Text("Lisää pelaaja"),
              //   onPressed: (){
              //     Player pelaaja = new Player(22, 0, 'Trenton', 'Thompson', 'Salon Vilpas', 33);
              //     CollectionReference dbCollectionRef = Firestore.instance.collection('players');
              //     Firestore.instance.runTransaction((Transaction tx) async {
              //       var result = await dbCollectionRef.add(pelaaja.toJson());
              //     });
              //     setState(() {

              //     });
              //   },
              // ),

              // RaisedButton(
              //   child: const Text("Lisää pelinumerot"),
              //   onPressed: (){
              //     AddPlayerNumbers();
              //     setState(() {

              //     });
              //   },
              // ),

              // Text("Pelaajat: "),
              // StreamBuilder(
              // stream: Firestore.instance.collection('players').snapshots(),
              // builder: (context, snapshot){
              //   if(!snapshot.hasData)
              //   {
              //     print("joo");
              //     return new CircularProgressIndicator();
              //   }
              //   else
              //   {
              //     print(snapshot.data);
              //     return new ListView.builder(
              //       shrinkWrap: true,
              //       itemExtent: 80.0,
              //       itemCount: snapshot.data.documents.length,
              //       itemBuilder: (context, index) =>
              //         buildListItem(context, snapshot.data.documents[index]),
              //     );
              //   }
              // }),
            ],
          ),
        ),
      ),
    );
  }

  Widget AddQuestionForms() {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Form(
          key: formKey,
          child: TextFormField(
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
        ),
        RaisedButton(
          onPressed: () {
            if (formKey.currentState.validate()) {
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text('Processing data')));
            }
          },
        ),
      ],
    );
  }

  void AddQuestion() async {
    Question question = new Question("Mikä oli Larry Poundsin pelinumero?",
        ["3", "9", "14", "25"], 3, "LarryPounds");
    CollectionReference dbCollectionRef =
        Firestore.instance.collection('questions');
    Firestore.instance.runTransaction((Transaction tx) async {
      var result = await dbCollectionRef.add(question.toJson());
    });
    setState(() {});
  }

  void AddPlayerNumbers() async {
    Random rnd = new Random();
    QuerySnapshot playersQuery =
        await Firestore.instance.collection('players').getDocuments();
    for (int i = 0; i < playersQuery.documents.length; i++) {
      final DocumentReference playerRef = Firestore.instance
          .collection('players')
          .document(playersQuery.documents[i].documentID);
      Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot freshSnap = await transaction.get(playerRef);
        await transaction.update(freshSnap.reference, {
          'playerNumber': (1 + rnd.nextInt(99 - 1)),
        });
      });
    }
  }

  void getVotingStartTime() async {
    DocumentReference gamesRef = await Firestore.instance
        .collection('games')
        .document('iSFhdMRlPSQWh3879pXL');
    DateTime convertedTime;
    gamesRef.get().then((DocumentSnapshot ds) {
      convertedTime = DateTime.fromMillisecondsSinceEpoch(
          ds['VotingStartTime'].millisecondsSinceEpoch);
      print(convertedTime.toString());
      //timeText = convertedTime.toString();
      votingEndTime = convertedTime.add(Duration(minutes: 3));
      timeText = votingEndTime.second.toString();
      customTimer =
          Timer.periodic(Duration(seconds: 1), (Timer t) => updateTimeLeft());
    });
  }

  void setVotingStartTime() async {
    resetPlayerVotes();
    DocumentReference gamesRef = await Firestore.instance
        .collection('games')
        .document('iSFhdMRlPSQWh3879pXL');
    DateTime currentTime = DateTime.now();
    FieldValue.serverTimestamp();
    gamesRef.setData({"VotingStartTime": currentTime});
  }

  void resetPlayerVotes() async {
    QuerySnapshot playersQuery =
        await Firestore.instance.collection('players').getDocuments();
    for (int i = 0; i < playersQuery.documents.length; i++) {
      final DocumentReference playerRef = Firestore.instance
          .collection('players')
          .document(playersQuery.documents[i].documentID);
      Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot freshSnap = await transaction.get(playerRef);
        await transaction.update(freshSnap.reference, {
          'currentVotes': 0,
        });
      });
    }
  }

  void updateTimeLeft() {
    Duration difference = votingEndTime.difference(DateTime.now());
    //timeText = new DateFormat.format(votingEndTime.difference(DateTime.now()));
    //timeText = DateFormat.MINUTE_SECOND;
    //timeText = (votingEndTime.minute - DateTime.now().minute).toString() + ':' + (votingEndTime.second - DateTime.now().second).toString();
    String seconds =
        ((difference.inMinutes * 60 - difference.inSeconds) * -1).toString();
    timeText = difference.inMinutes.toString() + ":" + seconds;
    print(timeText);
    setState(() {});
  }

  Widget buildListItem(BuildContext context, DocumentSnapshot document) {
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

  void userCounter() async{

    var t = await Firestore.instance.collection("users").getDocuments();
    usersATM = t.documents.length.toString();
    //t.asStream().length;

    //TOIMIS NY SOOTANA!

    var dbUsers = await Firestore.instance.collection("users");
    var dbLastSeen = dbUsers.where("lastSeen");
    dbLastSeen.snapshots().length;


    //print(dbUsers.toString() + " " + dbLastSeen.snapshots()..length.toString());


  }
}
