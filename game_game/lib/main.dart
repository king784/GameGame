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

  String homeTeam;
  String awayTeam;
  List<Player> allPlayers = new List<Player>();
  List<Player> homePlayers = new List<Player>();
  List<Player> awayPlayers = new List<Player>();

  String timeText = "";
  DateTime votingEndTime = null;
  Timer customTimer;

  @override
    Widget build(BuildContext context) {
      getGameValues();

      return Scaffold(
      appBar: AppBar(
        title: (
          Text('Pelaajaäänestys')),
          backgroundColor: Global.titleBarColor,
      ),
      body:
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Text(
              "Aikaa jäljellä: " + timeText,
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
        )
      );
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
      QuerySnapshot querySnapshot = await Firestore.instance.collection('players').getDocuments();
      List<DocumentSnapshot> playerSnapshot = new List<DocumentSnapshot>();
      playerSnapshot = querySnapshot.documents;
      String playersString = playerSnapshot.toString();
      print(playersString);
      Map playerMap;
      Player thePlayer;
      //Map playerMap = jsonDecode(jsonString);
      playerSnapshot.forEach((player) {
        //playerMap = jsonDecode(player.data.toString());
        thePlayer = new Player.fromJson(player.data);
        allPlayers.add(thePlayer);
      });

      // Get player voting start time and team names.
      DocumentReference gamesRef = await Firestore.instance.collection('games').document('iSFhdMRlPSQWh3879pXL');
      DateTime convertedTime;
      gamesRef.get().then((DocumentSnapshot ds){
        homeTeam = ds['HomeTeam'];
        awayTeam = ds['AwayTeam'];
        
        convertedTime = DateTime.fromMillisecondsSinceEpoch(ds['VotingStartTime'].millisecondsSinceEpoch);
        //print(convertedTime.toString());
        //timeText = convertedTime.toString();
        
        votingEndTime = convertedTime.add(Duration(minutes: 3));
        timeText = votingEndTime.second.toString();
        // Start timer which updates every second, and sets the text to show how much time is left in voting.
        customTimer = Timer.periodic(Duration(seconds: 1), (Timer t) => updateTimeLeft());
      });

       
    }

    // Updates the visible timer.
    void updateTimeLeft(){
      Duration difference = votingEndTime.difference(DateTime.now());   
      //timeText = new DateFormat.format(votingEndTime.difference(DateTime.now()));
      //timeText = DateFormat.MINUTE_SECOND;
      //timeText = (votingEndTime.minute - DateTime.now().minute).toString() + ':' + (votingEndTime.second - DateTime.now().second).toString();
      String seconds = ((difference.inMinutes * 60 - difference.inSeconds) * -1).toString();
      timeText = difference.inMinutes.toString() + ":" + seconds;
      //print(timeText);
      setState(() {});
    }

    Widget getPlayers()
    {
      if(allPlayers.length <= 0)
      {
        return CircularProgressIndicator();
      }
      else
      {
        List<Widget> list = new List<Widget>();
        for(int i = 0; i < allPlayers.length; i++)
        {
          list.add(new ListTile(
            title: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    allPlayers[i].firstName + ' ' + allPlayers[i].lastName,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    allPlayers[i].currentVotes.toString()
                  ),
                ),
              ],
            ),
          ));
        }
        return SizedBox(
          height: 2000,
          width: Global.SCREENWIDTH,
          child: ListView(
            shrinkWrap: true,
            children: list
          )
        );
      }
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
            Container(
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
              padding: const EdgeInsets.all(10.0),
              child: Text(
                document['currentVotes'].toString()
              ),
            ),
          ],
        ),
        onTap: () {
            Firestore.instance.runTransaction((transaction) async{
              DocumentSnapshot freshSnap = await transaction.get(document.reference);
                await transaction.update(freshSnap.reference, {
                  'currentVotes': freshSnap['currentVotes'] + 1,
                });
            });
        },
      );
    }
}