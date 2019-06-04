import 'package:flutter/material.dart';
import 'package:flutter_testuu/mainTrivia.dart';
import 'dart:async';
import 'Globals.dart';
import 'CustomMath.dart';
import 'Object.dart';

//void main() => runApp(MyApp());

class BallMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Arial',
      ),
      home: BallGame(),
    );
  }
}

class BallGame extends StatefulWidget {
  createState() => BallGameState();
}

class BallGameState extends State<BallGame> {
  int score = 0;
  double gravity = 0.5;

  Vector2 touchPos = new Vector2(0.0, 0.0);

  // Gameobjects
  Object ball = new Object(new Vector2(170.0, -10.0), new Vector2(50.0, 50.0), 'assets/ball.png');
  Object basket = new Object(new Vector2(0.0, 450.0), new Vector2(219.0, 161.0), 'assets/basket.png');

  bool firstRun = true;

  // Frame time calculations
  int currentFrame = 0;
  int deltaTimeInt = 0;
  int lastFrame = 0;

  @override
  Widget build(BuildContext context) {
    if(firstRun) {
      return Column(
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
                    color: Colors.green[700],
                    child: Text('Start'),
                    onPressed: () {
                      setState(() {
                        Global.GAMELOOP = true;
                        GameLoop();
                      });
                    },
                  ),
                  RaisedButton(
                    color: Colors.green[700],
                    child: Text('Stop'),
                    onPressed: () {
                      setState(() {
                        Global.GAMELOOP = false;
                      });
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      );
    }
    else
      {
        return Column(
            children: <Widget>[
              GestureDetector(
                onForcePressUpdate: (ForcePressDetails details) => SaveTouchPos(details),
                child: Container(
                  
                ),
              ),
              Transform.translate(
                offset: Offset(basket.position.x, basket.position.y),
                child: basket.GetAsset(),
              ),
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
                    color: Colors.green[400],
                  ),),
              ),
            ],
          );
      }
  }

  void GameLoop() async {
    // Runs only on first run.
    if (firstRun) {
      ball.position.x = CustomMath.getRandomDoubleBetweenRange(-Global.SCREENWIDTH + (ball.scale.x / 2), Global.SCREENWIDTH - (ball.scale.x / 2));
      ball.velocity = 0.0;
      ball.position.y = -ball.scale.y;
      firstRun = false;
    }
    while (Global.GAMELOOP) {
      CalculateDeltatime();
      // Ball stuff
      ball.velocity += gravity;
      ball.position.y += ball.velocity;
      if(ball.position.y > Global.SCREENHEIGHT) {
        score--;
        ball.position.x = CustomMath.getRandomDoubleBetweenRange(-Global.SCREENWIDTH + (ball.scale.x / 2), Global.SCREENWIDTH - (ball.scale.x / 2));
        ball.velocity = 0.0;
        ball.position.y = -ball.scale.y;
      }
      // Basket stuff
      basket.position.x = touchPos.x - Global.SCREENWIDTH;
      await new Future.delayed(const Duration(milliseconds: 17));
      setState(() {});
    }
  }

  void SaveTouchPos(ForcePressDetails details)
  {
    touchPos.x = details.globalPosition.dx;
    touchPos.y = details.globalPosition.dy;
  }

  void CalculateDeltatime() {
    currentFrame = DateTime.now().millisecond;
    deltaTimeInt = currentFrame - lastFrame;
    lastFrame = DateTime.now().millisecond;
  }
}
