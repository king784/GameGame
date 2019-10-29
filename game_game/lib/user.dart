import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_testuu/Globals.dart';

class User {
  // instance of current user
  User.userPrivate();
  static final User _instance = User.userPrivate();
  static User get instance {
    return _instance;
  }

  String displayName;
  String email;
  String uid;
  bool VIP;
  bool bannedFromChat;
  bool pictureAddedForCompetition;
  int watchedGames;
  int maxVotes, playerVotes, imageVotes;
  int pictureWins;
  List<DateTime> visitedGames = new List<DateTime>();

  User(String username, String newEmail, bool vip) {
    this.displayName = username;
    this.email = email;
    this.VIP = vip;
    this.bannedFromChat = false;
    this.watchedGames = 0;
    this.pictureWins = 0;
    this.pictureAddedForCompetition = false;

    if (VIP == true) {
      this.maxVotes = 5;
    } else {
      this.maxVotes = 1;
    }

    this.playerVotes = maxVotes;
    this.imageVotes = maxVotes;
  }

  void upgradeVipStatus() {
    this.VIP = true;
    this.maxVotes = 5;
  }

  void downgradeVipStatus() {
    this.VIP = false;
    this.maxVotes = 1;
  }

  void updateVotes() {
    this.imageVotes = this.maxVotes;
    this.playerVotes = this.maxVotes;
  }

  void visitGame(DateTime newGameDate) async {
    visitedGames.add(newGameDate);

    await Firestore.instance //get the document with the matching parameters
        .collection('users')
        .where('uid', isEqualTo: uid)
        .limit(1) //limit documents to 1
        .getDocuments()
        .then((val) {
      Firestore.instance.runTransaction((transaction) async {
        await transaction.update(val.documents[0].reference, {
          'visitedGames': visitedGames,
        });
        // //update the info in the document in database
        // DocumentSnapshot freshSnap = await transaction.get(val.documents[0]
        //     .reference); //get the reference  to our document we want to update
        // await transaction.update(freshSnap.reference, {
        //   'totalVotes': freshSnap
        // });
      });
    });
  }

  List<DateTime> GetVisitedGamesList(List<dynamic> temp) {
    //should you change this all suffering and the demise is on your shoulders
    List<DateTime> tempTimesList = new List<DateTime>();
    for (int i = 0; i < temp.length; i++) {
      Timestamp tempTimestamp = temp[i] as Timestamp;
      tempTimesList.add(tempTimestamp.toDate());
    }
    return tempTimesList;
  }

  void getVisitedGamesFromDB() async {
    //print("GetVisitedGamesFromDB Start");
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .limit(1)
        .getDocuments();
    if (querySnapshot.documents.length <= 0) {
      return;
    }
    visitedGames =
        GetVisitedGamesList(querySnapshot.documents[0]['visitedGames']);
    //print(Global.greenPen("VISITEDGAMESLENGTH!!!: " + visitedGames.length.toString()));
  }

  void getPictureWins(DocumentReference dr) {
    dr.get().then((DocumentSnapshot ds) {
      pictureWins = ds['pictureWins'];
    });
  }

  void voteForPlayer() async {
    playerVotes--;
    QuerySnapshot userQuery = await Firestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    final DocumentReference userRef = Firestore.instance
        .collection('users')
        .document(userQuery.documents[0].documentID);
    Firestore.instance.runTransaction(
      (transaction) async {
        DocumentSnapshot freshSnap = await transaction.get(userRef);
        await transaction.update(freshSnap.reference, {
          'playerVotes': freshSnap['playerVotes'] - 1,
        });
      },
    );
  }

  void voteForImage() async {
    imageVotes--;
    QuerySnapshot userQuery = await Firestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    final DocumentReference userRef = Firestore.instance
        .collection('users')
        .document(userQuery.documents[0].documentID);
    Firestore.instance.runTransaction(
      (transaction) async {
        DocumentSnapshot freshSnap = await transaction.get(userRef);
        await transaction.update(freshSnap.reference, {
          'imageVotes': freshSnap['imageVotes'] - 1,
        });
      },
    );
  }

  User.fromJson(Map<String, dynamic> json) {
    this.displayName = json['displayName'];
    this.email = json['email'];
    this.uid = json['uid'];
    var visitedGamesFromJson = json['visitedGames'];

    List<DateTime> visitedGamesList = visitedGamesFromJson.cast<DateTime>();
    for (int i = 0; i < visitedGamesList.length; i++) {
      this.visitedGames.add(visitedGamesList[i]);
    }
  }
}
