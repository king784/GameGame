import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_testuu/NavigationBar/topBar.dart';
import 'package:flutter_testuu/Themes/MasterTheme.dart';
import 'package:flutter_testuu/Globals.dart';
import '../user.dart';
import 'package:flutter_testuu/UserAuthentication.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  double screenWidth = Global.SCREENWIDTH * .9;
  int watchedGames = 0;
  double paddingVal = 10;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //onwill popscope disables the use of the android back button
      onWillPop: () async => false,
      child: Theme(
        data: MasterTheme.mainTheme,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: <Widget>[
                topBar(context, 'Omat tilastot'),
                Expanded(
                  child: Container(
                    height: Global.SCREENHEIGHT,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: screenWidth,
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.all(paddingVal),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Katsotut kotiottelut:',
                                      textAlign: TextAlign.left,
                                      style: Theme.of(context).textTheme.body1,
                                    ),
                                    Text(
                                      User.instance.visitedGames.length > 0
                                          ? User.instance.visitedGames.length
                                              .toString()
                                          : "0",
                                      textAlign: TextAlign.left,
                                      style: Theme.of(context).textTheme.title,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: screenWidth,
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.all(paddingVal),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Voitetut kuvaäänestykset:',
                                      textAlign: TextAlign.left,
                                      style: Theme.of(context).textTheme.body1,
                                    ),
                                    Text(
                                      User.instance.pictureWins.toString(),
                                      textAlign: TextAlign.left,
                                      style: Theme.of(context).textTheme.title,
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
                Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: Global.SCREENWIDTH / 2,
                      child: RaisedButton(
                        color: MasterTheme.awayTeamColour,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(0),
                              child: Text(
                                'Poista käyttäjä',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.button,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          signOut();
                          print("Tilisi poistettu äksdee :D");
                        },
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getSeenGames() {
    this.watchedGames = 0;
  }

  void signOut() async {
    User.instance.firebaseAuth.signOut();
    print("Firebase authenticator sign out");
    User.instance.googleSignIn.signOut();
    print("Google sign out");

    //Delete!!
    //Tyhjennä databeis

    User.instance.user.delete();
  }
}
