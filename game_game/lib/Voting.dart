// https://www.youtube.com/watch?v=R12ks4yDpMM
// https://www.youtube.com/watch?v=DqJ_KjFzL9I

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:async';
import 'dart:math';
import 'Globals.dart';
import 'Navigation.dart';
import 'Themes/MasterTheme.dart';
import 'user.dart';

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

  // Dropdown variables
  String sortValue = "Pelaajanumero";
  final List<String> sortValues = ['Pelaajanumero', 'Etunimi', 'Sukunimi'];

  // Voting timer variables
  String timeText = "";
  DateTime votingEndTime;
  Timer customTimer;
  bool votingDone = false;

  // Do initialization stuff if first run
  bool firstRun = true;
  bool playersGot = false;
  bool valuesOnce = true;

  // DEBUG USER
  User fakeUser = new User("Sportacus", false);

  @override
  Widget build(BuildContext context) {
    if (valuesOnce) {
      getGameValues();
      valuesOnce = false;
    }

    if (votingDone) {
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
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                    alignment: Alignment.center,
                    child: Column(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Äänestys on ohi!",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                            "Voittajat: ",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline,
                        ),
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: getWinners(),
                      ),
                    ],)
                      
                    ),
              ),
            ],
          )),
        ),
      );
    }
    if (!playersGot) {
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

              Padding(
                padding: EdgeInsets.all(30.0),
                child: Text(
                  timeText,
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),

              Column(
                children: <Widget>[
                  getPlayers(),

              ],)

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
          )),
        ),
      );
    } else {
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

              Row(children: <Widget>[
                Expanded(
                child: Text(
                  timeText,
                  style: Theme.of(context).textTheme.subhead,
                ),
              ),
              ],),
              

              Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Text(
                  "Ääniä jäljellä: " + fakeUser.playerVotes.toString(),
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.subhead,
                ),
              ),

              Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("Järjestys: ",
                          style: new TextStyle(
                            fontSize: 20.0,
                          )),
                      Center(
                        child: DropdownButton<String>(
                          value: sortValue,
                          onChanged: (String newValue) {
                            setState(() {
                              sortValue = newValue;
                              sortPlayers(sortValue);
                            });
                          },
                          items: sortValues
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Row(children: <Widget>[
                Expanded(child:  Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Text(
                  "Etsi pelaaja:",
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.body1,
                ),
              ),),
               
              Expanded(child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 150,
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
              ),
            ),
            ]),
              

              Column(
                children: <Widget>[
                  buildFilteredPlayers(),

              ],)
              
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
          )),
        ),
      );
    }
  }

  List<Widget> getWinners() {
    List<Widget> winnerPlayers = new List<Widget>();
    allPlayers.sort((a, b) => a.currentVotes.compareTo(b.currentVotes));
    List<int> winnerVotes = new List<int>();
    for (int i = 0; i < allPlayers.length; i++) {
      winnerVotes.add(allPlayers[i].currentVotes);
    }
    int winnerVote = winnerVotes.reduce(max);
    for (int i = 0; i < allPlayers.length; i++) {
      if (allPlayers[i].currentVotes == winnerVote) {
        winnerPlayers.add(
          SizedBox(
            width: Global.SCREENWIDTH * 0.8,
            child: Card(
              color: MasterTheme.bgBoxColour,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        allPlayers[i].firstName + ' ' + allPlayers[i].lastName,
                        style: allPlayers[i].team == "KTP" // Check if home team or away
                            ? new TextStyle(
                                color: MasterTheme.accentColour,
                                fontFamily: Theme.of(context).textTheme.subhead.fontFamily,
                                fontSize: Theme.of(context).textTheme.subhead.fontSize
                              )
                            : new TextStyle(
                                color: MasterTheme.awayTeamColour,
                                fontFamily: Theme.of(context).textTheme.subhead.fontFamily,
                                fontSize: Theme.of(context).textTheme.subhead.fontSize
                              ),
                      ),
                    ),
                    Text(
                      "Ääniä: " + allPlayers[i].currentVotes.toString(),
                      style: Theme.of(context).textTheme.body1,
                    )
                  ]),
              ),
            ),
          ),
          
        );
      }
    }
    return winnerPlayers;
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

    // Set listener
    var playerSnaps =
        await Firestore.instance.collection('players').snapshots();
    Player tempPlayer;
    playerSnaps.listen((data) {
      data.documentChanges.forEach((change) {
        // print("JEE: ");
        // print(change.document.data.toString());
        tempPlayer = new Player.fromJson(change.document.data);
        for (int i = 0; i < allPlayers.length; i++) {
          if (allPlayers[i].id == tempPlayer.id) {
            allPlayers[i].currentVotes++;
            i = allPlayers.length;
          }
        }
      });
    });

    QuerySnapshot querySnapshot =
        await Firestore.instance.collection('players').getDocuments();

    List<DocumentSnapshot> playerSnapshot = new List<DocumentSnapshot>();

    playerSnapshot = querySnapshot.documents;
    Player thePlayer;
    //Map playerMap = jsonDecode(jsonString);
    playerSnapshot.forEach((player) {
      //playerMap = jsonDecode(player.data.toString());
      thePlayer = new Player.fromJson(player.data);
      print(thePlayer.id);
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
    playersGot = true;
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
      votingDone = true;
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
          if (searchIcon.icon == Icons.close) {
            searchIcon = new Icon(Icons.search);
          }
        });
      } else {
        setState(() {
          if (searchIcon.icon == Icons.search) {
            searchIcon = new Icon(Icons.close);
          }
          searchText = filter.text;
        });
      }
    });
  }

  void searchPressed() {
    setState(() {
      if (searchIcon.icon == Icons.search) {
        searchIcon = new Icon(Icons.close);
      } else {
        searchIcon = new Icon(Icons.search);
        filteredPlayers = allPlayers;
        filter.clear();
      }
    });
  }

  Widget getPlayers() {
    playerWidgets.clear();
    if (allPlayers.length <= 0) {
      return Center(child: CircularProgressIndicator());
    } else {
      if (firstRun) {
        firstRun = false;

        allPlayers.sort((a, b) => a.playerNumber.compareTo(b.playerNumber));
        List<Widget> list = new List<Widget>();
        list.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 250,
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
            onTap: () {
              giveVote(i);
            },
            title: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    allPlayers[i].firstName + ' ' + allPlayers[i].lastName,
                    style: setTeamColors(i),
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
        addFilterListener();
      }

      return Column(
        children: filteredPlayerWidgets,
        
      );

      // return Expanded(
      //     child: SingleChildScrollView(
      //         child:
      //             ListView(shrinkWrap: true, children: filteredPlayerWidgets)));
    }
  }

  void sortPlayers(String newSortValue) {
    switch (newSortValue) {
      case "Pelaajanumero":
        allPlayers.sort((a, b) => a.playerNumber.compareTo(b.playerNumber));
        break;
      case "Etunimi":
        allPlayers.sort((a, b) => a.firstName.compareTo(b.firstName));
        break;
      case "Sukunimi":
        allPlayers.sort((a, b) => a.lastName.compareTo(b.lastName));
        break;

      default:
        allPlayers.sort((a, b) => a.playerNumber.compareTo(b.playerNumber));
        print(
            "Code should never go here. If it did, something is wrong, learn to code you dumbo.");
        break;
    }
  }

  Widget buildFilteredPlayers() {
    filteredPlayerWidgets.clear();
    List<Widget> list = new List<Widget>();
    list.clear();
    if (searchText.isEmpty) {
      for (int i = 0; i < allPlayers.length; i++) {
        print(setTeamColors(i));
        list.add(ListTile(
          //dense: true,
          onTap: () {
            //giveVote(i);
            showVotePopup(i);
          },
          title: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  allPlayers[i].firstName + ' ' + allPlayers[i].lastName,
                  style: setTeamColors(i),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Text(allPlayers[i].currentVotes.toString()),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            onTap: () {
              //giveVote(i);
              showVotePopup(i);
            },
            title: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    allPlayers[i].firstName + ' ' + allPlayers[i].lastName,
                    style: setTeamColors(i),
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
      }
      setState(() {
        filteredPlayerWidgets = list;
      });
    }

    return Column(
        children: filteredPlayerWidgets,
        
      );

    // return Expanded(
    //     //child: SingleChildScrollView(
    //     child: ListView(shrinkWrap: true, children: filteredPlayerWidgets));
    //)
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

  TextStyle setTeamColors(int i) {
    if (allPlayers[i].team == "KTP") {
      return TextStyle(
        color: MasterTheme.accentColour,
        //background: Paint()..color = Colors.white,
      );
    } else {
      return TextStyle(
        color: MasterTheme.awayTeamColour,
      );
    }
  }

  void showVotePopup(int i) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          if (fakeUser.playerVotes > 0) {
            return Theme(
              data: MasterTheme.mainTheme,
              child: AlertDialog(
                title: new Text("Annatko äänen pelaajalle " +
                    allPlayers[i].firstName +
                    " " +
                    allPlayers[i].lastName),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("Kyllä"),
                    onPressed: () {
                      giveVote(i);
                      Navigator.of(context).pop();
                    },
                  ),
                  new FlatButton(
                    child: new Text(
                      "En",
                      style: TextStyle(
                        color: MasterTheme.awayTeamColour,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          } else {
            return Theme(
              data: MasterTheme.mainTheme,
              child: AlertDialog(
                title: new Text("Ei ääniä jäljellä."),
                actions: <Widget>[
                  new FlatButton(
                    child: new Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: new Text(
                            "Nyyh",
                            style: TextStyle(
                              color: MasterTheme.awayTeamColour,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: new Icon(
                            FontAwesomeIcons.sadTear,
                            color: MasterTheme.awayTeamColour,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          }
        });
  }

  void giveVote(int i) async {
    // allPlayers[i].currentVotes++;
    // DocumentReference gamesRef = await Firestore.instance
    //     .collection('players')
    //     .document('-LhAU5GSvy91YLuAHU7S');

    // print("Jee");

    // setState(() {
    //   Firestore.instance.runTransaction((transaction) async {
    //       DocumentSnapshot freshSnap =
    //           await transaction.get(gamesRef);
    //       await transaction.update(freshSnap.reference, {
    //         'currentVotes': freshSnap['currentVotes'] + 1,
    //       });
    //     });
    // });

    // works!
    // Firestore.instance.collection('players').where('ID', isEqualTo: i).snapshots().listen(
    //   (data) => print(data.documents[0]['firstName'])
    // );

    // var streamRef = Firestore.instance.collection('players').where('ID', isEqualTo: i).snapshots().listen(
    //   (data) => {
    //     Firestore.instance.runTransaction((transaction) async {
    //         DocumentSnapshot freshSnap = await transaction.get(data.documents[0].reference);
    //         await transaction.update(freshSnap.reference, {
    //           'currentVotes': freshSnap['currentVotes'] + 1,
    //         });
    //       })
    //   }//print(data.documents[0]['firstName'])
    // );

    //print(allPlayers[i].firstName + " " + allPlayers[i].lastName + " " + allPlayers[i].id.toString());

    QuerySnapshot playersQuery = await Firestore.instance
        .collection('players')
        .where('ID', isEqualTo: allPlayers[i].id)
        .getDocuments();
    final DocumentReference playerRef = Firestore.instance
        .collection('players')
        .document(playersQuery.documents[0].documentID);
    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot freshSnap = await transaction.get(playerRef);
      await transaction.update(freshSnap.reference, {
        'currentVotes': freshSnap['currentVotes'] + 1,
      }).then((data) {
        setState(() {
          //allPlayers[i].currentVotes++;
          fakeUser.playerVotes--;
        });
      });
    });
  }
}
