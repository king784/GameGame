import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

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
      return Column(children: <Widget>[
        Text("jee"),
      ],);
    }
}