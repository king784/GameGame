// https://www.youtube.com/watch?v=R12ks4yDpMM
// https://www.youtube.com/watch?v=DqJ_KjFzL9I
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
      return Scaffold(
      appBar: AppBar(
        title: (
          Text('Vote the best player!')),
      ),
      body:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
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