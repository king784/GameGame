import 'package:flutter/material.dart';
import 'dart:async';
import 'CustomMath.dart';
import 'Object.dart';

//void main() => runApp(MyApp());

// Global variables
bool GAMELOOP = true;
double SCREENWIDTH, SCREENHEIGHT;

class BallMain extends StatelessWidget {
  void intializeValues(BuildContext context) {
    SCREENWIDTH = MediaQuery.of(context).size.width;
    SCREENWIDTH /= 2.0;
    SCREENHEIGHT = MediaQuery.of(context).size.height;
  }

  @override
  Widget build(BuildContext context) {
    intializeValues(context);
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
                        GAMELOOP = true;
                        GameLoop();
                      });
                    },
                  ),
                  RaisedButton(
                    color: Colors.green[700],
                    child: Text('Stop'),
                    onPressed: () {
                      setState(() {
                        GAMELOOP = false;
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
        return GestureDetector(
          onTapDown: (TapDownDetails details) => SaveTouchPos(details),
          child: Column(
            children: <Widget>[
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
          ),
        );
      }
  }

  void GameLoop() async {
    // Runs only on first run.
    if (firstRun) {
      ball.position.x = CustomMath.getRandomDoubleBetweenRange(-SCREENWIDTH + (ball.scale.x / 2), SCREENWIDTH - (ball.scale.x / 2));
      ball.velocity = 0.0;
      ball.position.y = -ball.scale.y;
      firstRun = false;
    }
    while (GAMELOOP) {
      CalculateDeltatime();
      // Ball stuff
      ball.velocity += gravity;
      ball.position.y += ball.velocity;
      if(ball.position.y > SCREENHEIGHT) {
        score--;
        ball.position.x = CustomMath.getRandomDoubleBetweenRange(-SCREENWIDTH + (ball.scale.x / 2), SCREENWIDTH - (ball.scale.x / 2));
        ball.velocity = 0.0;
        ball.position.y = -ball.scale.y;
      }
      // Basket stuff
      basket.position.x = touchPos.x - SCREENWIDTH;
      await new Future.delayed(const Duration(milliseconds: 17));
      setState(() {});
    }
  }

  void SaveTouchPos(TapDownDetails details)
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
