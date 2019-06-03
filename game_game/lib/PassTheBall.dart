import 'package:flutter/material.dart';
import 'package:flutter_testuu/CustomMath.dart';
import 'package:flutter_testuu/Globals.dart';
import 'Object.dart';

class PassTheBallMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Arial',
      ),
      home: PassTheBallGame(),
    );
  }
}

class PassTheBallGame extends StatefulWidget {
  @override
  State<StatefulWidget> createState(){
    return PassTheBallState();
  }
}

class PassTheBallState extends State<PassTheBallGame> {
  int score = 0;
  double gravity = 0.5;

  Vector2 touchPos = new Vector2(0.0, 0.0);

  Object ball = new Object(
      new Vector2(100.0, 100.0), new Vector2(50.0, 50.0), "assets/ball.png");

  bool firstRun = true;
  bool bounce = false;

  int currentFrame = 0;
  int deltaTimeInt = 0;
  int lastFrame = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (firstRun) {
      return new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: <Widget>[
          Transform.translate(
            offset: Offset(ball.position.x, ball.position.y),
            child: ball.GetAsset(),
          ),
          Center(
            child: Card(
              child: Column(
                children: <Widget>[
                  RaisedButton(
                    color: Colors.green,
                    child: Text("Start"),
                    onPressed: () {
                      setState(() {
                        Global.GAMELOOP = true;
                        GameLoop();
                      });
                    },
                  )
                ],
              ),
            ),
          )
        ],
      );
    }

    else {
      return GestureDetector(
        onTapDown: (TapDownDetails details) => (SaveTouchPos(details)),
        child: Column(
          children: <Widget>[
            Transform.translate(
              offset: Offset(ball.position.x, ball.position.y),
              child: ball.GetAsset(),
            ),

            Align(
              alignment: Alignment.topLeft,
              child: Text(
                score.toString(),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
            ),
            RaisedButton(
              onPressed: () {
                bounce = true;
              },
            )

          ],
        ),
      );
    }
  }

  void GameLoop() async {
    if (firstRun) {
      ball.position.x = Global.SCREENWIDTH / 2;
      ball.velocity = 0.0;
      ball.position.y = -ball.scale.y;
      firstRun = false;
    }
    while (Global.GAMELOOP) {
      CalculateDeltatime();

      if(bounce){
        ball.position.y += ball.velocity * -1;
        if(ball.position.y < 10)
          bounce = false;
      }
      else {
        ball.velocity += gravity;
        ball.position.y += ball.velocity;
        if (ball.position.y > Global.SCREENHEIGHT) {
          ball.position.y = -ball.scale.y;
          ball.velocity = 0.0;
        }
      }
      await new Future.delayed(const Duration(milliseconds: 17));
      setState(() {});
    }
  }

  void CalculateDeltatime() {
    currentFrame = DateTime.now().millisecond;
    deltaTimeInt = currentFrame - lastFrame;
    lastFrame = DateTime.now().millisecond;
  }

  void SaveTouchPos(TapDownDetails details){
    touchPos.x = details.globalPosition.dx;
    touchPos.y = details.globalPosition.dy;
  }
}

