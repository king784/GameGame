import 'dart:async';

import 'pages/main.dart';
//import 'mainTrivia.dart';
import 'Globals.dart';
import 'dart:math';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'dart:async' show Future;
import 'package:path/path.dart' as p;
import "dart:io";
import 'package:path_provider/path_provider.dart';

class ktpQuiz{

  var images = [
    "Halli", "pepe2", "pepe3", "Halli2", "kentta"];


  var choices=[
    ["Kotkan uimahalli", "Steveco areena", "Eduskunta talo", "Karhuvuoren koulu"],
    ["10", "8", "5", "12"],
    ["1", "24", "99", "14"],
    ["8", "6", "4", "10"],
    ["25 x 14", "29 x 16", "28 x 15", "31 x 17"]
  ];

  var correctAnswers=[
    "Steveco areena", "10", "14", "4", "28 x 15"
  ];
}

String getContents;

var finalScore = 0;
var questionNumber = 0;
var quiz = new ktpQuiz();
List<int> randNums = [0, 1, 2, 3];
int rand1, rand2, rand3, rand4;
bool firstRun = true;

int timeLeft = 10;

class Trivia extends StatefulWidget{
  @override
  State<StatefulWidget> createState(){
    return new TriviaState();
  }
}

//class TimerPainter extends CustomPainter{
//  TimerPainter({
//    this.animation,
//    this.backgroundColor,
//    this.color,
//  }) : super(repaint: animation);
//  final Animation<double> animation;
//  final Color backgroundColor, color;
//
//  void paint(Canvas canvas, Size size){
//    Paint paint = Paint()
//    ..color = backgroundColor
//    ..strokeWidth = 5.0
//    ..strokeCap = StrokeCap.round
//    ..style = PaintingStyle.stroke;
//
//
//  canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);
//  paint.color = color;
//  double progress = (1.0 - animation.value) * 2 * 3.14;
//  canvas.drawArc(Offset.zero & size, 3.14 * 1.5, -progress, false, paint);
//  }
//
//@override
//bool shouldRepaint(TimerPainter old){
//  return animation.value != old.animation.value ||
//  color != old.color ||
//  backgroundColor != old.backgroundColor;
//}
//}

class TriviaState extends State<Trivia> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    //Style variables
    double buttonsWidth = screenWidth / 3;
    double buttonHeight = screenHeight / 10;

    Startade();

    List<List<String>> quizContents = new List<List<String>>();
    quizContents.add(Global.contents.split(";"));
    // TODO: implement build
    return new WillPopScope(
        child: Scaffold(
          body: new Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                  image: new AssetImage("images/backGround.jpg"),
                  fit: BoxFit.fill,
                  colorFilter: new ColorFilter.mode(
                      Colors.white.withOpacity(0.15), BlendMode.dstATop)
                //fit: BoxFit.cover,
              ),
            ),
            //margin: const EdgeInsets.all(10.0),
            alignment: Alignment.topCenter,
            child: new Column(
              children: <Widget>[

                //new Text(readFromFile,
                new Text(quizContents[0][questionNumber],
                //new Text(quiz.questions[questionNumber],
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    fontSize: screenHeight / 25,
                  ),
                ),

                new Text("Aika: ${timeLeft}",
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    fontSize: screenHeight / 25,
                  ),
                ),

                new Image.asset("images/${quiz.images[questionNumber]}.jpg",
                  height: screenHeight / 2.5, width: screenWidth,),

                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[

                    //
                    //Buttons
                    //

                    //Button1
                    new MaterialButton(
                      padding: EdgeInsets.all(10),
                      minWidth: buttonsWidth,
                      height: buttonHeight,
                      color: Colors.black12,
                      onPressed: () {
                        if (quiz.choices[questionNumber][rand1] ==
                            quiz.correctAnswers[questionNumber]) {
                          finalScore++;
                        }
                        else {
                        }
                        updateQuestion();
                      },
                      child: new Text(
                        quiz.choices[questionNumber][rand1],
                        style: new TextStyle(
                            fontSize: buttonsWidth / 7,
                            color: Colors.white
                        ),
                      ),
                    ),

                    //Button2
                    new MaterialButton(
                      padding: EdgeInsets.all(10),
                      minWidth: buttonsWidth,
                      height: buttonHeight,
                      color: Colors.black12,
                      onPressed: () {
                        if (quiz.choices[questionNumber][rand2] ==
                            quiz.correctAnswers[questionNumber]) {
                          finalScore++;
                        }
                        else {
                        }
                        updateQuestion();
                      },
                      child: new Text(
                        quiz.choices[questionNumber][rand2],
                        style: new TextStyle(
                            fontSize: buttonsWidth / 7,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ],
                ),
                new Row(children: <Widget>[new Text(" ")],),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    //Button3
                    new MaterialButton(
                      padding: EdgeInsets.all(10),
                      minWidth: buttonsWidth,
                      height: buttonHeight,
                      color: Colors.black12,
                      onPressed: () {
                        if (quiz.choices[questionNumber][rand3] ==
                            quiz.correctAnswers[questionNumber]) {
                          finalScore++;
                        }
                        else {
                        }
                        updateQuestion();
                      },
                      child: new Text(
                        quiz.choices[questionNumber][rand3],
                        style: new TextStyle(
                            fontSize: buttonsWidth / 7,
                            color: Colors.white
                        ),
                      ),
                    ),


                    //Button4
                    new MaterialButton(
                      padding: EdgeInsets.all(10),
                      minWidth: buttonsWidth,
                      height: buttonHeight,
                      color: Colors.black12,
                      onPressed: () {
                        if (quiz.choices[questionNumber][rand4] ==
                            quiz.correctAnswers[questionNumber]) {
                          finalScore++;
                        }
                        else {
                        }
                        updateQuestion();
                      },
                      child:
                      new Text(quiz.choices[questionNumber][rand4],
                        style: new TextStyle(
                            fontSize: buttonsWidth / 7,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ],
                ),

                new Row(children: <Widget>[new Text(" ")],),
                new Container(
                  alignment: Alignment.bottomCenter,
                  child: new MaterialButton(
                    color: Colors.red,
                    minWidth: buttonsWidth,
                    height: buttonHeight,
                    onPressed: resetQuiz,
                    child: new Text("Quit",
                      style: new TextStyle(
                          fontSize: 20.0,
                          color: Colors.white
                      ),
                    ),

                  ),
                )

              ],
            ),
          ),
        ),
        onWillPop: () async => false);
  }

  void Startade() async{
    if(firstRun)
    {
      //loadQuestions();
      //await loadQuestions();
      RandomizeQuestions();
      ReAddValues();
      firstRun = false;
    }
  }

void _timer() async{
  setState(() {
    timeLeft = 10;    
    Timer.periodic(Duration(seconds: 1), (timer) {
      timeLeft--;
      print(timeLeft);
    });   
  });
}

  void resetQuiz() {
    setState(() {
      Navigator.pop(context);
      finalScore = 0;
      questionNumber = 0;
    });
  }


  void updateQuestion() {
    setState(() {
      timeLeft = 10;
      if (questionNumber == Global.contents.split(";").length - 1) {
        Navigator.push(context, new MaterialPageRoute(
            builder: (context) => new Summary(score: finalScore)));
      }
      else {
        questionNumber++;
        RandomizeQuestions();
        ReAddValues();
      }
    });
  }

  void RandomizeQuestions()
  {
    //timeLeft = 10;
    rand1 = randNums.removeAt(Random().nextInt(randNums.length));
    rand2 = randNums.removeAt(Random().nextInt(randNums.length));
    rand3 = randNums.removeAt(Random().nextInt(randNums.length));
    rand4 = randNums.removeAt(Random().nextInt(randNums.length));
  }

  void ReAddValues()
  {
    randNums.clear();
    for(int i = 0; i < 4; i++)
    {
      randNums.add(i);
    }
  }
}

String scoreText(final int score){
  double percentage = (((score).toDouble()) / Global.contents.split(";").length) * 100;

  if(percentage <= 15)
    return "Harmillista. Sait vain $score pistettä.";

  else if(percentage >=16 && percentage <= 45)
    return "Noh.. Ainahan sitä voi vähän petrata. Pisteesi: $score";

  else if(percentage >=46 && percentage <= 94)
    return "Nyt alkaa näyttämään jo hyvältä. Pisteesi: $score";

  else
    return "Hurraa!! Sait kaikki oikein. Pisteesi: $score";
}

class Summary extends StatelessWidget {
  final int score;

  Summary({Key key, @required this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    double buttonsWidth = screenWidth / 3;
    double buttonHeight = screenHeight / 10;

    // TODO: implement build
    return new WillPopScope(child: Scaffold(

      body: new Container(

          decoration: new BoxDecoration(
              image: new DecorationImage(
                  image: new AssetImage("images/Halli2.jpg"),
                  colorFilter: new ColorFilter.mode(
                      Colors.white.withOpacity(0.15), BlendMode.dstATop)
                //fit: BoxFit.cover,
              )
          ),

          child: new Column(
            mainAxisAlignment: MainAxisAlignment.end,

            children: <Widget>[

              new Text(scoreText(score) + "\n\n\n\n",
                textAlign: TextAlign.center,
                style: new TextStyle(
                  fontSize: 30,
                ),
              ),

              new MaterialButton(
                color: Colors.lightGreen,
                minWidth: buttonsWidth,
                height: buttonHeight,
                onPressed: () {
                  questionNumber = 0;
                  finalScore = 0;
                  Navigator.pop(context);
                },
                child: new Text("Yritä uudelleen",
                  style: TextStyle(
                      fontSize: buttonsWidth / 7,
                      color: Colors.white
                  ),
                ),
              ),

              new Text("\n\n\n"),


              new MaterialButton(
                  color: Colors.green,
                  minWidth: buttonsWidth,
                  height: buttonHeight,
                  child: new Text("Palaa valikkoon",
                    style: TextStyle(
                      fontSize: buttonsWidth / 7,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    TriviaState triviaState = new TriviaState();
                    triviaState.resetQuiz();
                  }
              ),

              new Text("\n\n\n"),

            ],
          )

      ),

    ),

        onWillPop: () async => false);
  }

}
