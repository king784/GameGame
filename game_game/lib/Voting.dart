// https://www.youtube.com/watch?v=R12ks4yDpMM
// https://www.youtube.com/watch?v=DqJ_KjFzL9I
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
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
  // Variables to hold the information about players
  String homeTeam;
  String awayTeam;
  List<Player> allPlayers = new List<Player>();
  List<Player> homePlayers = new List<Player>();
  List<Player> awayPlayers = new List<Player>();
  List<Widget> playerWidgets = new List<Widget>();

  // Searchbar variables
  final TextEditingController filter = new TextEditingController();
  String searchText = "";
  List<Player> filteredPlayers = new List<Player>();
  List<Widget> filteredPlayerWidgets = new List<Widget>();
  Icon searchIcon = new Icon(Icons.search);
  String textBarHint = 'Etsi Pelaajaa';

  // Voting timer variables
  String timeText = "";
  DateTime votingEndTime;
  Timer customTimer;

  // Do initialization stuff if first run
  bool firstRun = true;
  bool playersGot = false;
  bool valuesOnce = true;

  @override
  Widget build(BuildContext context) {
    if(valuesOnce)
    {
      getGameValues();
      valuesOnce = false;
    }

    if(!playersGot)
    {
    return Scaffold(
        appBar: AppBar(
          title: (Text('Pelaajaäänestys')),
          backgroundColor: Global.titleBarColor,
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Text(
                timeText,
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
            getPlayers(),
            // StreamBuilder(
            // stream: Firestore.instance.collection('players').snapshots(),
            // builder: (context, snapshot){
            //   if(!snapshot.hasData)
            //   {
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
        )));
    }
    else
    {
      return Scaffold(
        appBar: AppBar(
          title: (Text('Pelaajaäänestys')),
          backgroundColor: Global.titleBarColor,
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Text(
                timeText,
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
            buildFilteredPlayers(),
            // StreamBuilder(
            // stream: Firestore.instance.collection('players').snapshots(),
            // builder: (context, snapshot){
            //   if(!snapshot.hasData)
            //   {
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
        )));
    }
  }

  // Function to get needed values from database. Gets the start time of voting, so we can start calculating how much time is left.
  // Also retrieves the names of the playing teams.
  void getGameValues() async {
    // Get players in their own lists.
    // CollectionReference playersRef = await Firestore.instance.collection('players');
    // playersRef. .get().then(function(querySnapshot) {
    //   querySnapshot.forEach(function(doc) {

    //   })
    // })
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection('players').getDocuments();
    List<DocumentSnapshot> playerSnapshot = new List<DocumentSnapshot>();
    playerSnapshot = querySnapshot.documents;
    Player thePlayer;
    //Map playerMap = jsonDecode(jsonString);
    playerSnapshot.forEach((player) {
      //playerMap = jsonDecode(player.data.toString());
      thePlayer = new Player.fromJson(player.data);
      allPlayers.add(thePlayer);
    });

    // Get player voting start time and team names.
    DocumentReference gamesRef = await Firestore.instance
        .collection('games')
        .document('iSFhdMRlPSQWh3879pXL');
    DateTime convertedTime;
    gamesRef.get().then((DocumentSnapshot ds) {
      homeTeam = ds['HomeTeam'];
      awayTeam = ds['AwayTeam'];

      convertedTime = DateTime.fromMillisecondsSinceEpoch(
          ds['VotingStartTime'].millisecondsSinceEpoch);
      //print(convertedTime.toString());
      //timeText = convertedTime.toString();

      votingEndTime = convertedTime.add(Duration(minutes: 3));
      timeText = votingEndTime.second.toString();
      // Start timer which updates every second, and sets the text to show how much time is left in voting.
      customTimer =
          Timer.periodic(Duration(seconds: 1), (Timer t) => updateTimeLeft());
    });
  }

  // Updates the visible timer.
  void updateTimeLeft() {
    Duration difference = votingEndTime.difference(DateTime.now());
    //timeText = new DateFormat.format(votingEndTime.difference(DateTime.now()));
    //timeText = DateFormat.MINUTE_SECOND;
    //timeText = (votingEndTime.minute - DateTime.now().minute).toString() + ':' + (votingEndTime.second - DateTime.now().second).toString();
    if (((difference.inMinutes * 60 - difference.inSeconds) * -1) < 0) {
      timeText = "Äänestys on loppunut";
      customTimer.cancel();
    } else {
      String seconds =
          ((difference.inMinutes * 60 - difference.inSeconds) * -1).toString();
      timeText =
          "Aikaa jäljellä: " + difference.inMinutes.toString() + ":" + seconds;
    }
    //print(timeText);
    setState(() {});
  }

  // Adds a listerer to the searchbar
  void addFilterListener() {
    filter.addListener(() {
      if (filter.text.isEmpty) {
        setState(() {
          searchText = "";
          filteredPlayers = allPlayers;
        });
      } else {
        setState(() {
          searchText = filter.text;
        });
      }
    });
  }

  void searchPressed()
  {
    setState(() {
     if(searchIcon.icon == Icons.search)
     {
       searchIcon = new Icon(Icons.close);
     }
     else
     {
       searchIcon = new Icon(Icons.search);
       filteredPlayers = allPlayers;
       filter.clear();
     } 
    });
  }

  Widget getPlayers() {
    playerWidgets.clear();
    if (allPlayers.length <= 0) {
      return CircularProgressIndicator();
    } else {
      if (firstRun) {
        firstRun = false;
        List<Widget> list = new List<Widget>();
        list.add(Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: filter,
              ),
            ),
            IconButton(
              icon: searchIcon,
              onPressed: () {
                searchPressed();
              },
            ),
          ],
        ));
        for (int i = 0; i < allPlayers.length; i++) {
          list.add(ListTile(
            title: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    allPlayers[i].firstName + ' ' + allPlayers[i].lastName,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(allPlayers[i].currentVotes.toString()),
                ),
              ],
            ),
          ));
        }
        setState(() {
          playerWidgets = list;
          filteredPlayerWidgets = playerWidgets;
        });
        
        playersGot = true;
        addFilterListener();
      }

      return Expanded(
              child: SingleChildScrollView(
            child:
                ListView(shrinkWrap: true, children: filteredPlayerWidgets)));
    }
  }

  Widget buildFilteredPlayers() {
    filteredPlayerWidgets.clear();
    List<Widget> list = new List<Widget>();
    list.clear();
    list.add(Row(
      children: <Widget>[
        Flexible(
          child: TextField(
            controller: filter,
          ),
        ),
        IconButton(
          icon: searchIcon,
          onPressed: () {
            searchPressed();
          },
        ),
      ],
    ));
    if (searchText.isEmpty) {
      for (int i = 0; i < allPlayers.length; i++) {
        list.add(ListTile(
          title: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  allPlayers[i].firstName + ' ' + allPlayers[i].lastName,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Text(allPlayers[i].currentVotes.toString()),
              ),
            ],
          ),
        ));
      }
      setState(() {
          playerWidgets = list;
          filteredPlayerWidgets = playerWidgets;
        });
    } else {
      for (int i = 0; i < allPlayers.length; i++) {
        // Check if search text matches first or last name
        if ((allPlayers[i]
                .firstName
                .toLowerCase()
                .contains(searchText.toLowerCase())) ||
            (allPlayers[i]
                .lastName
                .toLowerCase()
                .contains(searchText.toLowerCase()))) {
          list.add(ListTile(
            title: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    allPlayers[i].firstName + ' ' + allPlayers[i].lastName,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(filteredPlayers[i].currentVotes.toString()),
                ),
              ],
            ),
          ));
        }
        setState(() {
          filteredPlayerWidgets = list;
        });
      }
    }

    return Expanded(
              child: SingleChildScrollView(
            child:
                ListView(shrinkWrap: true, children: filteredPlayerWidgets)));

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
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
            ),
            padding: const EdgeInsets.all(10.0),
            child: Text(document['currentVotes'].toString()),
          ),
        ],
      ),
      onTap: () {
        Firestore.instance.runTransaction((transaction) async {
          DocumentSnapshot freshSnap =
              await transaction.get(document.reference);
          await transaction.update(freshSnap.reference, {
            'currentVotes': freshSnap['currentVotes'] + 1,
          });
        });
      },
    );
  }
}
