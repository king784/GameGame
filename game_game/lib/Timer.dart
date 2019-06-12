import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Globals.dart';
import 'dart:async';

void main() => runApp(TimerTestMain());

class TimerTestMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Arial',
      ),
      home: TimerTest(),
    );
  }
}

String text = ''; 
int timer;
Timer customTimer;


class TimerTest extends StatefulWidget {
  createState() => TimerTestState();
}

class TimerTestState extends State<TimerTest> {

  @override
    Widget build(BuildContext context) {
      if(text == '')
      {
        timer = 10;
        customTimer = Timer.periodic(Duration(seconds: 1), (Timer t) => DoTimerStuff());
      }
      return Text(text);
    }

    DoTimerStuff()
    {
      timer -= 1;
      String theText;
      if(timer < -3)
      {
        timer = 10;
        theText = timer.toString();
      }
      else if(timer < 0)
      {
        theText = 'Hävisit Pelin!!!';
      }
      else
      {
        theText = timer.toString();
      }
      setState(() {
        text = theText;
      });
    }
}