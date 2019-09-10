import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_testuu/Admin/AddPlayer.dart';
import 'package:flutter_testuu/Admin/AddQuestions.dart';
import 'package:flutter_testuu/route_generator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../Globals.dart';
import '../Navigation.dart';
import '../Themes/MasterTheme.dart';
import 'deletePlayer.dart';
import 'deleteQuestion.dart';
import 'gameDay.dart';
import 'AddGameCode.dart';

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
  double wantedWidth = 0.7;
  bool firstTime = true;

  var usersATM;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (firstTime) {
      Global.intializeValues(
          MediaQuery.of(context).size.width, MediaQuery.of(context).size.width);
      firstTime = false;
    }
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
                          onPressed: () =>
                              Navigation.openActivitiesPage(context),
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
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: Global.SCREENWIDTH * 0.7,
                                      child: RaisedButton(
                      color: MasterTheme.accentColour,
                      child: Text(
                        "Aloita 3 minuutin ajastin",
                        style: Theme.of(context).textTheme.button,
                      ),
                      onPressed: () {
                        setVotingStartTime();
                        //getVotingStartTime();
                        //print(DateTime.now().toString());
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(
                    width: Global.SCREENWIDTH * 0.7,
                    child: RaisedButton(
                      color: MasterTheme.accentColour,
                      child: Text(
                        "Kerro paljon aikaa",
                        style: Theme.of(context).textTheme.button,
                      ),
                      onPressed: () {
                        getVotingStartTime();
                        //print(DateTime.now().toString());
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(
                    width: Global.SCREENWIDTH * 0.7,
                    child: RaisedButton(
                      color: MasterTheme.accentColour,
                      child: Text(
                        "Lisää kysymys",
                        style: Theme.of(context).textTheme.button,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddQuestionForm()),
                        );
                        //AddQuestion();
                        //print(DateTime.now().toString());
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(
                    width: Global.SCREENWIDTH * 0.7,
                    child: RaisedButton(
                      color: MasterTheme.accentColour,
                      child: Text(
                        "Lisää pelaaja",
                        style: Theme.of(context).textTheme.button,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddPlayerForm()),
                        );
                        //AddQuestion();
                        //print(DateTime.now().toString());
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(
                    width: Global.SCREENWIDTH * 0.7,
                                      child: RaisedButton(
                      color: MasterTheme.accentColour,
                      child: Text(
                        "Lisää pelipäivä",
                        style: Theme.of(context).textTheme.button,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddGamedayForm()),
                        );
                        //AddQuestion();
                        //print(DateTime.now().toString());
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(
                    width: Global.SCREENWIDTH * 0.7,
                                      child: RaisedButton(
                      color: MasterTheme.accentColour,
                      child: Text(
                        "Lisää pelikoodi",
                        style: Theme.of(context).textTheme.button,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddGameCodeForm()),
                        );
                        //AddQuestion();
                        //print(DateTime.now().toString());
                        setState(() {});
                      },
                    ),
                  ),
                  Text(timeText),
                  usersATM != null ? Text(usersATM) : Text("Odota hetki"),
                  SizedBox(
                    width: Global.SCREENWIDTH * 0.7,
                                      child: RaisedButton(
                      color: MasterTheme.accentColour,
                      child: Text(
                        "Poista kysymys",
                        style: Theme.of(context).textTheme.button,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DeleteQuestionForm()),
                        );
                        //AddQuestion();
                        //print(DateTime.now().toString());
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(
                    width: Global.SCREENWIDTH * 0.7,
                                      child: RaisedButton(
                      color: MasterTheme.accentColour,
                      child: Text(
                        "Poista pelaaja",
                        style: Theme.of(context).textTheme.button,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DeletePlayerForm()),
                        );
                        //AddQuestion();
                        //print(DateTime.now().toString());
                        setState(() {});
                      },
                    ),
                  ),
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
        ["3", "9", "14", "25"], 3, "LarryPounds", DateTime.now());
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

  void userCounter() async {
    //TOIMIS NY SAATANA!

    final QuerySnapshot result = await Firestore.instance
        .collection('users')
        .limit(1) //limits documents to one
        .getDocuments();

    final QuerySnapshot gamingDayDb = await Firestore.instance
        .collection('gamingDay')
        .limit(1) //limits documents to one
        .getDocuments();

    DateTime gameDay; // = DateTime(2019, 8, 17);
    gameDay = gamingDayDb.documents[0]['activeDay'].toDate();
    DateTime lastSeen;

    lastSeen = result.documents[0]['lastSeen'].toDate();

    //Checks if the game date time is equal to users last logged date time
    if (lastSeen.year == gameDay.year &&
        lastSeen.month == gameDay.month &&
        lastSeen.day == gameDay.day) {
      print("Today is a game day. Game time: " +
          gameDay.hour.toString() +
          " to " +
          (gameDay.hour + 3).toString());
      if (lastSeen.hour >= gameDay.hour && lastSeen.hour <= gameDay.hour + 3) {
        print("Player active");

        var t = await Firestore.instance.collection("users").getDocuments();
        usersATM = t.documents.length.toString() + " aktiivista käyttäjää";
      }
    } else {
      usersATM = "Ei aktiivisia käyttäjiä";
    }
    setState(() {});
  }
}
