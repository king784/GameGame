import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'NavigationBar/Navigation.dart';
import 'Themes/MasterTheme.dart';
import 'Globals.dart';
import 'dart:math';
import 'package:flutter/material.dart';

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
  static bool reFetchQuestion = false;
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
  bool noQuestionsNow = false;
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
    return noQuestionsNow
        ? WillPopScope(
            onWillPop: () async => false,
            child: Theme(
              data: MasterTheme.mainTheme,
              child: Scaffold(
                body: SafeArea(
                  child: Column(
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
                                  onPressed: () =>
                                      Navigation.openActivitiesPage(context),
                                  elevation: 0),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  'Trivia',
                                  textAlign: TextAlign.right,
                                  style: Theme.of(context).textTheme.title,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    "Trivia ei ole käynnissä nyt.",
                                    style: Theme.of(context).textTheme.subtitle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : !questionsLoaded
            ? WillPopScope(
                onWillPop: () async => false,
                child: Theme(
                  data: MasterTheme.mainTheme,
                  child: Scaffold(
                    body: SafeArea(
                      child: Column(
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
                                      onPressed: () =>
                                          Navigation.openActivitiesPage(
                                              context),
                                      elevation: 0),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Text(
                                      'Trivia',
                                      textAlign: TextAlign.right,
                                      style: Theme.of(context).textTheme.title,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Text(
                                        "Ladataan...",
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      ),
                                    ),
                                    CircularProgressIndicator(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : WillPopScope(
                onWillPop: () async => false,
                child: Theme(
                  data: MasterTheme.mainTheme,
                  child: Scaffold(
                    body: SafeArea(
                      child: Column(
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
                                      onPressed: () {
                                        questions.clear();
                                        questions.addAll(allQuestions);
                                        currentQuestion = questions.removeAt(
                                            Random().nextInt(questions.length));
                                        questionNumber = 0;
                                        finalScore = 0;
                                        Navigation.openActivitiesPage(context);
                                        // Navigation.openPage(context, 'activities');
                                        questionsLoaded = true;
                                        // customTimer.cancel();
                                        customTimer = null;
                                        timeLeft = 10;
                                        Navigation.openActivitiesPage(context);
                                      },
                                      elevation: 0),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Text(
                                      'Trivia',
                                      textAlign: TextAlign.right,
                                      style: Theme.of(context).textTheme.title,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Column(
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
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: new Text(
                                                  currentQuestion.question,
                                                  textAlign: TextAlign.center,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .display3,
                                                ),
                                              ),

                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        5.0, 0.0, 5.0, 0.0),
                                                child: nextImgLoaded
                                                    ? SizedBox(
                                                        height: 300,
                                                        child: nextImage,
                                                      )
                                                    : SizedBox.shrink(),
                                              ),

                                              new Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,

                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,

                                                children: <Widget>[
                                                  //

                                                  //Buttons

                                                  //

                                                  //Button1

                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: new MaterialButton(
                                                        //padding: EdgeInsets.all(10),

                                                        //minWidth: buttonsWidth,

                                                        height:
                                                            buttonHeight / 1.2,

                                                        color: Colors.green,

                                                        onPressed: () {
                                                          if (currentQuestion
                                                                  .correct ==
                                                              0) {
                                                            finalScore++;
                                                          } else {}

                                                          GetNextQuestion();
                                                        },

                                                        child: new Text(
                                                          currentQuestion
                                                              .choices[0],
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .button,
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  //Button2

                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: new MaterialButton(
                                                        //padding: EdgeInsets.all(10),

                                                        //minWidth: buttonsWidth,

                                                        height:
                                                            buttonHeight / 1.2,

                                                        color: Colors.green,

                                                        onPressed: () {
                                                          if (currentQuestion
                                                                  .correct ==
                                                              1) {
                                                            finalScore++;
                                                          } else {}

                                                          GetNextQuestion();
                                                        },

                                                        child: new Text(
                                                          currentQuestion
                                                              .choices[1],
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .button,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],

                                                //),
                                              ),

                                              new Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  //Button3

                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: new MaterialButton(
                                                        //padding: EdgeInsets.all(10),

                                                        //minWidth: buttonsWidth,

                                                        height:
                                                            buttonHeight / 1.2,

                                                        color: Colors.green,

                                                        onPressed: () {
                                                          if (currentQuestion
                                                                  .correct ==
                                                              2) {
                                                            finalScore++;
                                                          } else {}

                                                          GetNextQuestion();
                                                        },

                                                        child: new Text(
                                                          currentQuestion
                                                              .choices[2],
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .button,
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  //Button4

                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: new MaterialButton(
                                                        //padding: EdgeInsets.all(10),

                                                        //minWidth: buttonsWidth,

                                                        height:
                                                            buttonHeight / 1.2,

                                                        color: Colors.green,

                                                        onPressed: () {
                                                          if (currentQuestion
                                                                  .correct ==
                                                              3) {
                                                            finalScore++;
                                                          } else {}

                                                          GetNextQuestion();
                                                        },

                                                        child: new Text(
                                                          currentQuestion
                                                              .choices[3],
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .button,
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
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
  }

  void Startade() async {
    if (firstRun) {
      //loadQuestions();
      //await loadQuestions();
      await LoadQuestions();
      if (noQuestionsNow) {
        return;
      } else {
        RandomizeQuestions();
        ReAddValues();
        NextImage(currentQuestion.imagePath);
        firstRun = false;
      }
    }

    if (!noQuestionsNow) {
      if (Trivia.reFetchQuestion) {
        NextImage(currentQuestion.imagePath);
        Trivia.reFetchQuestion = false;
      }
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
  }

  void TimerFunction() {
    print(timeLeft);
    timeLeft = timeLeft - 1;
    if (timeLeft == 0) {
      timeLeft = 10;
      GetNextQuestion();
    }
    setState(() {});
  }

  void LoadQuestions() async {
    DateTime startOfToday = DateTime.now();
    startOfToday = DateTime(
        startOfToday.year, startOfToday.month, startOfToday.day, 0, 0, 0, 0);
    DateTime endOfToday = startOfToday;
    endOfToday = DateTime(
        endOfToday.year, endOfToday.month, endOfToday.day, 23, 59, 59, 999);

    QuerySnapshot querySnapshot = await Firestore.instance
        .collection('questions')
        .where('questionTime', isLessThan: endOfToday)
        .where('questionTime', isGreaterThan: startOfToday)
        .getDocuments();

    List<DocumentSnapshot> questionSnapshot = new List<DocumentSnapshot>();
    questionSnapshot = querySnapshot.documents;
    Question tempQuestion;
    questionSnapshot.forEach((q) {
      tempQuestion = new Question.fromJson(q.data);
      allQuestions.add(tempQuestion);
    });

    if (allQuestions.length <= 0) {
      Global.greenPen("ffs");
      setState(() {
        noQuestionsNow = true;
      });
    } else {
      questions.addAll(allQuestions);
      currentQuestion = GetRandomQuestion();

      questionsLoaded = true;
      NextImage(currentQuestion.imagePath);
      setState(() {});
    }
  }

  Question GetRandomQuestion() {
    return questions.removeAt(Random().nextInt(questions.length));
  }

  void NextImage(String nextUrl) async {
    nextImgLoaded = false;
    if (nextUrl != "" && nextUrl != null) {
      final ref =
          FirebaseStorage.instance.ref().child("Quizes/1/" + nextUrl + ".jpg");
      var url = await ref.getDownloadURL();

      nextImage = Image.network(url);
      nextImgLoaded = true;
      setState(() {});
    }
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
      } else {
        currentQuestion = GetRandomQuestion();
        NextImage(currentQuestion.imagePath);
        // if (currentQuestion.imagePath == "" ||
        //     currentQuestion.imagePath == null) {
        //   nextImage = null;
        //   nextImgLoaded = false;
        // } else {
        //   NextImage(currentQuestion.imagePath);
        // }
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
  String theText = "";

  if (percentage <= 15) {
    theText = "Harmillista. Sait vain $score" +
        "/" +
        allQuestions.length.toString() +
        " pistettä.";
  } else if (percentage >= 16 && percentage <= 45) {
    theText = "Noh.. Ainahan sitä voi vähän petrata. Pisteesi: $score";
    theText += "/" + allQuestions.length.toString();
  } else if (percentage >= 46 && percentage <= 94) {
    theText = "Nyt alkaa näyttämään jo hyvältä. Pisteesi: $score";
    theText += "/" + allQuestions.length.toString();
  } else {
    theText = "Hurraa!! Sait kaikki oikein. Pisteesi: $score";
    theText += "/" + allQuestions.length.toString();
  }

  return theText;
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
        onWillPop: () async => false,
        child: Theme(
          data: MasterTheme.mainTheme,
          child: Scaffold(
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                          child: FloatingActionButton(
                              heroTag: 'backBtn5',
                              child: Icon(
                                FontAwesomeIcons.arrowLeft,
                                color: MasterTheme.accentColour,
                                size: 40,
                              ),
                              backgroundColor: Colors.transparent,
                              //onPressed: () => Navigation.openPage(context, 'activities'),
                              onPressed: () {
                                if (allQuestions.length > 0) {
                                  questions.clear();
                                  questions.addAll(allQuestions);
                                  currentQuestion = questions.removeAt(
                                      Random().nextInt(questions.length));
                                  //NextImage(currentQuestion.imagePath);
                                  questionNumber = 0;
                                  finalScore = 0;
                                  questionsLoaded = true;
                                  Navigation.openActivitiesPage(context);
                                  // Navigation.openPage(context, 'activities');
                                  // customTimer.cancel();
                                  // customTimer = null;
                                  // timeLeft = 10;
                                }
                              },
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
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Text(scoreText(finalScore),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.display3),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
