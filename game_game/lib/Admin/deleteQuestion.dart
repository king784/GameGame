import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Themes/MasterTheme.dart';
import 'package:flutter_testuu/Globals.dart';

class DeleteQuestionForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DeleteQuestionFormState();
  }
}

class DeleteQuestionFormState extends State<DeleteQuestionForm> {
  var sortValue = "joopa";
  List<String> allQuestions = new List<String>();
  List<Widget> theList = new List<Widget>();
  bool loaded = false;
  Icon searchIcon = new Icon(Icons.search);
  String searchText = "";
  final TextEditingController filter = new TextEditingController();
  List<String> lisOfAllQuestions = new List<String>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Theme(
        data: MasterTheme.mainTheme,
        child: Scaffold(
            body: ListView(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                    child: FloatingActionButton(
                        heroTag: 'backBtn3',
                        child: Icon(
                          FontAwesomeIcons.arrowLeft,
                          color: MasterTheme.accentColour,
                          size: 40,
                        ),
                        backgroundColor: Colors.transparent,
                        onPressed: () => Navigator.pop(context),
                        elevation: 0),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Poista kysymys',
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Row(children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Text(
                    "Etsi kysymys:",
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.body1,
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 150,
                      child: TextField(
                          controller: filter,
                          ),
                    ),
                    IconButton(
                      icon: searchIcon,
                      onPressed: () {
                        searchPressed();
                      },
                    ),
                  ],
                ),
              ),
            ]),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                children: TheTexts(), //JOUJOUJOUJOUJOUJOUJOUJOUOJOUOJOOOJOUO
              ),
            ),
          ],
        )),
      ),
    );
  }

  List<Widget> TheTexts() {
    theList.clear();
    if (!loaded) {
      addFilterListener();
      loadQuestions();
      loaded = true;
    }

    for (int i = 0; i < allQuestions.length; i++) {
      if(searchText == ""){

      theList.add(RaisedButton(
        child: Text(
          allQuestions[i],
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.button,
        ),
        onPressed: () {
          _deleteQuestion(i);
        },
        color: MasterTheme.accentColour,
      ));
      }
      else if(allQuestions[i].toLowerCase().contains(searchText.toLowerCase())){
        theList.add(RaisedButton(
          child: Text(
            allQuestions[i],
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.button,
          ),
          onPressed: () {
            _deleteQuestion(i);
          },
          color: MasterTheme.accentColour,
        ));
      }
    }
    setState(() {
      
    });
    return theList;
  }

  void loadQuestions() async {
    final QuerySnapshot result = await Firestore.instance
        .collection('questions')
        .getDocuments();

    for (int i = 0; i < result.documents.length; i++) {
      allQuestions.add(result.documents[i]["question"].toString());
    }

    setState(() {});
  }

  _deleteQuestion(int index) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Haluatko poistaa kysymyksen?'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  SizedBox(
                    width: Global.SCREENWIDTH * .9,
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RaisedButton(
                        child: Text('Haluan',
                            style: Theme.of(context).textTheme.body1),
                        onPressed: () async {
                          await Firestore.instance.collection('questions').where('question', isEqualTo: allQuestions[index]).limit(1).getDocuments().then((val){
                            val.documents[0].reference.delete();
                          });
                          print("Question at " + index.toString() + " deleted");
                          setState(() {
                            allQuestions.removeAt(index);
                            theList.clear();
                            //loadQuestions();
                            Navigator.of(context).pop(context);    
                          });
                        },
                        color: Theme.of(context).accentColor,
                      ),
                      RaisedButton(
                        child: Text('Peruuta',
                            style: Theme.of(context).textTheme.body1),
                        onPressed: () {
                          Navigator.of(context).pop(context);
                        },
                        color: MasterTheme.awayTeamColour,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
      void addFilterListener() {
    filter.addListener(() {
      if (filter.text.isEmpty) {
        setState(() {
          searchText = "";
        lisOfAllQuestions = allQuestions;
          if (searchIcon.icon == Icons.close) {
            searchIcon = new Icon(Icons.search);
          }
        });
      } else {
        setState(() {
          if (searchIcon.icon == Icons.search) {
            searchIcon = new Icon(Icons.close);
          }
          searchText = filter.text;
          print(searchText);
        });
      }
    });
  }
    void searchPressed() {
    setState(() {
      print("search");
      if (searchIcon.icon == Icons.search) {
        searchIcon = new Icon(Icons.close);
      } else {
        searchIcon = new Icon(Icons.search);
        lisOfAllQuestions = allQuestions;
        filter.clear();
      }
    });
  }
  
}
