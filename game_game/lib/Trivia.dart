import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_testuu/Timer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'Navigation.dart';
import 'Themes/MasterTheme.dart';
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

class ktpQuiz {
  //var questions = ["Mikä rakennus näkyy kuvassa?", "Mikä on Larry poundsin jäädytetyn pelipaidan numero?", ]

  var images = ["Halli", "pepe2", "pepe3", "Halli2", "kentta"];

  var choices = [
    [
      "Kotkan uimahalli",
      "Steveco areena",
      "Eduskunta talo",
      "Karhuvuoren koulu"
    ],
    ["10", "8", "5", "12"],
    ["1", "24", "99", "14"],
    ["8", "6", "4", "10"],
    ["25 x 14", "29 x 16", "28 x 15", "31 x 17"]
  ];

  var correctAnswers = ["Steveco areena", "10", "14", "4", "28 x 15"];
}

String getContents;

var finalScore = 0;
var questionNumber = 0;
var quiz = new ktpQuiz();
List<int> randNums = [0, 1, 2, 3];
int rand1, rand2, rand3, rand4;
bool firstRun = true;
List<Question> allQuestions = new List<Question>();
// questions list is used to randomize question from all questions and pop it out of the list
List<Question> questions = new List<Question>();
Question currentQuestion;
typedef GetNextQuestionCallback = void Function();
bool questionsLoaded = false;

int timeLeft = 10;

class Trivia extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new TriviaState();
  }
}

// class TimerPainter extends CustomPainter{
//  TimerPainter({
//    this.animation,
//    this.backgroundColor,
//    this.color,
//  }) : super(repaint: animation);
//  final Animation<double> animation;
//  final Color backgroundColor, color;

//  void paint(Canvas canvas, Size size){
//    Paint paint = Paint()
//    ..color = backgroundColor
//    ..strokeWidth = 5.0
//    ..strokeCap = StrokeCap.round
//    ..style = PaintingStyle.stroke;


//  canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);
//  paint.color = color;
//  double progress = (1.0 - animation.value) * 2 * 3.14;
//  canvas.drawArc(Offset.zero & size, 3.14 * 1.5, -progress, false, paint);
//  }

// @override
// bool shouldRepaint(TimerPainter old){
//  return animation.value != old.animation.value ||
//  color != old.color ||
//  backgroundColor != old.backgroundColor;
// }
// }

class TriviaState extends State<Trivia> with TickerProviderStateMixin {
  // Question variables
  Image nextImage;
  bool nextImgLoaded = false;
  int questionIndex = 0;

  Timer customTimer;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    //Style variables
    double buttonsWidth = screenWidth / 3;
    double buttonHeight = screenHeight / 10;

    Startade();

    List<List<String>> quizContents = new List<List<String>>();
    quizContents.add(Global.contents.split(";"));
    // TODO: implement build
    return !questionsLoaded
        ? new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Ladataan...",
                  style: Theme.of(context).textTheme.subtitle,
                ),
              ),
              CircularProgressIndicator(),
            ],
          )
        : new WillPopScope(
            child: Theme(
              data: MasterTheme.mainTheme,
              child: Scaffold(
                  bottomNavigationBar: BottomAppBar(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: FloatingActionButton(
                              heroTag: 'backBtn7',
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Icon(
                                      FontAwesomeIcons.arrowLeft,
                                      color: MasterTheme.primaryColour,
                                      size: 40,
                                    ),
                                  ),
                                  Text("Luovuta",
                                      style:
                                          Theme.of(context).textTheme.subtitle),
                                ],
                              ),
                              backgroundColor: Colors.transparent,
                              onPressed: () {
                                questions.clear();
                                questions.addAll(allQuestions);
                                currentQuestion = questions.removeAt(
                                    Random().nextInt(questions.length));
                                questionNumber = 0;
                                finalScore = 0;
                                Navigation.openGamesFromTrivia(context);
                                questionsLoaded = true;
                                customTimer.cancel();
                                customTimer = null;
                                timeLeft = 10;
                              },
                              elevation: 0),
                        ),
                        Expanded(
                          child: Text(""),
                        ),
                      ],
                    ),
                  ),
                  body: new ListView(
                    children: <Widget>[
                      // Padding(
                      //   padding: const EdgeInsets.all(10.0),
                      //   child: new Text(
                      //     "Aika: " + timeLeft.toString(),
                      //     textAlign: TextAlign.center,
                      //     style: Theme.of(context).textTheme.display2,
                      //   ),
                      // ),
                      Card(
                        margin: EdgeInsets.all(5.0),
                        child: Column(
                          children: <Widget>[
                            //new Text(readFromFile,

                            //new Text(quizContents[0][questionNumber],

                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: new Text(
                                currentQuestion.question,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.display3,
                              ),
                            ),

                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                              child: nextImgLoaded
                                  ? SizedBox(
                                      height: 300,
                                      child: nextImage,
                                    )
                                  : CircularProgressIndicator(),
                            ),

                            new Row(
                              mainAxisAlignment: MainAxisAlignment.center,

                              crossAxisAlignment: CrossAxisAlignment.center,

                              children: <Widget>[
                                //

                                //Buttons

                                //

                                //Button1

                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: new MaterialButton(
                                      //padding: EdgeInsets.all(10),

                                      //minWidth: buttonsWidth,

                                      height: buttonHeight / 1.2,

                                      color: Colors.green,

                                      onPressed: () {
                                        if (currentQuestion.correct == 0) {
                                          finalScore++;
                                        } else {}

                                        GetNextQuestion();
                                      },

                                      child: new Text(
                                        currentQuestion.choices[0],
                                        style: new TextStyle(
                                            fontSize: buttonsWidth / 7,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),

                                //Button2

                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: new MaterialButton(
                                      //padding: EdgeInsets.all(10),

                                      //minWidth: buttonsWidth,

                                      height: buttonHeight / 1.2,

                                      color: Colors.green,

                                      onPressed: () {
                                        if (currentQuestion.correct == 1) {
                                          finalScore++;
                                        } else {}

                                        GetNextQuestion();
                                      },

                                      child: new Text(
                                        currentQuestion.choices[1],
                                        style: new TextStyle(
                                            fontSize: buttonsWidth / 7,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],

                              //),
                            ),

                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                //Button3

                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: new MaterialButton(
                                      //padding: EdgeInsets.all(10),

                                      //minWidth: buttonsWidth,

                                      height: buttonHeight / 1.2,

                                      color: Colors.green,

                                      onPressed: () {
                                        if (currentQuestion.correct == 2) {
                                          finalScore++;
                                        } else {}

                                        GetNextQuestion();
                                      },

                                      child: new Text(
                                        currentQuestion.choices[2],
                                        style: new TextStyle(
                                            fontSize: buttonsWidth / 7,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),

                                //Button4

                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: new MaterialButton(
                                      //padding: EdgeInsets.all(10),

                                      //minWidth: buttonsWidth,

                                      height: buttonHeight / 1.2,

                                      color: Colors.green,

                                      onPressed: () {
                                        if (currentQuestion.correct == 3) {
                                          finalScore++;
                                        } else {}

                                        GetNextQuestion();
                                      },

                                      child: new Text(
                                        currentQuestion.choices[3],
                                        style: new TextStyle(
                                            fontSize: buttonsWidth / 7,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            //],
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
            onWillPop: () async => false
            //),
            );
  }

  void Startade() async {
    if (firstRun) {
      //loadQuestions();
      //await loadQuestions();
      await LoadQuestions();
      RandomizeQuestions();
      ReAddValues();
      firstRun = false;
    }

    // if(customTimer == null && Global.CURRENTROUTE == "/trivia")
    // {
    //   customTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) => TimerFunction());
    // }

    // if(Global.CURRENTROUTE != "/trivia")
    // {
    //   customTimer = null;
    //   timeLeft = 0;
    // }

    if(!nextImgLoaded && currentQuestion != null)
    {
      NextImage(currentQuestion.imagePath);
    }
  }

  void TimerFunction()
  {
    print(timeLeft);
    timeLeft =  timeLeft - 1;
    if(timeLeft == 0)
    {
      timeLeft = 10;
      GetNextQuestion();
    }
    setState(() {});
  }

  void LoadQuestions() async {
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection('questions').getDocuments();

    List<DocumentSnapshot> questionSnapshot = new List<DocumentSnapshot>();
    questionSnapshot = querySnapshot.documents;
    Question tempQuestion;
    questionSnapshot.forEach((q) {
      tempQuestion = new Question.fromJson(q.data);
      allQuestions.add(tempQuestion);
    });

    questions.addAll(allQuestions);
    currentQuestion = GetRandomQuestion();

    questionsLoaded = true;
    NextImage(currentQuestion.imagePath);
    setState(() {});
  }

  Question GetRandomQuestion() {
    return questions.removeAt(Random().nextInt(questions.length));
  }

  void NextImage(String nextUrl) async {
    nextImgLoaded = false;
    final ref =
        FirebaseStorage.instance.ref().child("Quizes/1/" + nextUrl + ".jpg");
    var url = await ref.getDownloadURL();

    nextImage = Image.network(url);
    nextImgLoaded = true;
    setState(() {});
  }

  void _timer() async {
    setState(() {
      timeLeft = 10;
      Timer.periodic(Duration(seconds: 1), (timer) {
        timeLeft--;
        // print(timeLeft);
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

  void GetNextQuestion() {
    print("AllquestionsLength: " + allQuestions.length.toString());
    print("QuestionsLength: " + questions.length.toString());
    setState(() {
      timeLeft = 10;
      if (questions.length <= 0) {
        Navigation.openSummary(context); 
      }
      else {
        currentQuestion = GetRandomQuestion();
        NextImage(currentQuestion.imagePath);
        setState(() {});
      }
    });
  }

  void updateQuestion() {
    setState(() {
      timeLeft = 10;
      if (questionNumber == Global.contents.split(";").length - 1) {
        Navigation.openSummary(context); 
      } else {
        questionNumber++;
        RandomizeQuestions();
        ReAddValues();
      }
    });
  }

  void RandomizeQuestions() {
    //timeLeft = 10;
    rand1 = randNums.removeAt(Random().nextInt(randNums.length));
    rand2 = randNums.removeAt(Random().nextInt(randNums.length));
    rand3 = randNums.removeAt(Random().nextInt(randNums.length));
    rand4 = randNums.removeAt(Random().nextInt(randNums.length));
  }

  void ReAddValues() {
    randNums.clear();
    for (int i = 0; i < 4; i++) {
      randNums.add(i);
    }
  }
}

String scoreText(final int score) {
  double percentage = (((score).toDouble()) / allQuestions.length) * 100;
  print("Percentage: " + percentage.toString());

  if (percentage <= 15)
    return "Harmillista. Sait vain $score pistettä.";
  else if (percentage >= 16 && percentage <= 45)
    return "Noh.. Ainahan sitä voi vähän petrata. Pisteesi: $score";
  else if (percentage >= 46 && percentage <= 94)
    return "Nyt alkaa näyttämään jo hyvältä. Pisteesi: $score";
  else
    return "Hurraa!! Sait kaikki oikein. Pisteesi: $score";
}

class Summary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double buttonsWidth = screenWidth / 3;
    double buttonHeight = screenHeight / 10;

    // TODO: implement build
    return new WillPopScope(
        child: Scaffold(
          bottomNavigationBar: BottomAppBar(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: FloatingActionButton(
                      heroTag: 'backBtn5',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(
                              FontAwesomeIcons.arrowLeft,
                              color: MasterTheme.primaryColour,
                              size: 40,
                            ),
                          ),
                          Text("Palaa",
                              style: Theme.of(context).textTheme.subtitle),
                        ],
                      ),
                      backgroundColor: Colors.transparent,
                      onPressed: () {
                        questions.clear();
                        questions.addAll(allQuestions);
                        currentQuestion = questions
                            .removeAt(Random().nextInt(questions.length));
                        questionNumber = 0;
                        finalScore = 0;
                        Navigation.openGamesFromTrivia(context);
                        questionsLoaded = true;
                        customTimer.cancel();
                        customTimer = null;
                        timeLeft = 10;
                      },
                      elevation: 0),
                ),
                Expanded(
                  child: FloatingActionButton(
                      heroTag: 'backBtn6',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text("Yritä uudelleen",
                              style: Theme.of(context).textTheme.subtitle),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(
                              FontAwesomeIcons.arrowRight,
                              color: MasterTheme.primaryColour,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.transparent,
                      onPressed: () {
                        questions.clear();
                        questions.addAll(allQuestions);
                        currentQuestion = questions
                            .removeAt(Random().nextInt(questions.length));
                        questionNumber = 0;
                        finalScore = 0;
                        Navigation.openGamesFromTrivia(context);
                        questionsLoaded = true;
                        customTimer.cancel();
                        customTimer = null;
                        timeLeft = 10;
                      },
                      elevation: 0),
                ),
              ],
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(scoreText(finalScore),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.display3),
            ],
          ),
        ),
        onWillPop: () async => false);
  }
}
