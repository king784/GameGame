import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  @override
    Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        title: (
          Text('Add players')),
      ),
      body:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: const Text("Aloita 3 minuutin ajastin."),
              onPressed: (){
                // CollectionReference dbCollectionRef = Firestore.instance.collection('games');
                // print(DateTime.now().toString());
              },
            ),
            RaisedButton(
              child: const Text("Lisää pelimies"),
              onPressed: (){
                Player pelaaja = new Player(0, 'Peli', 'Mies', 'KTP');
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