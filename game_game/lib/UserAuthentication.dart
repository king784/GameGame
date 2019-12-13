import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_testuu/Globals.dart';
import 'package:flutter_testuu/TermsPopUp.dart';
import 'package:flutter_testuu/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
//import 'package:';

import 'NavigationBar/Navigation.dart';
import 'Themes/MasterTheme.dart';
import 'StartPageForm.dart';
import 'pages/main.dart';

class UserAuthentication extends StatelessWidget {
  bool firstTime = false;

  @override
  Widget build(BuildContext context) {
    if (!firstTime) {
      User user = User.instance;
      firstTime = true;
    }
    return MaterialApp(
      title: "Kirjautuminen",
      theme: MasterTheme.mainTheme,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Kirjautuminen"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              UserProfile(),
              LoginButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  var googleUser;

  Observable<FirebaseUser> user;
  Observable<Map<String, dynamic>> profile;
  PublishSubject loading = PublishSubject();

  AuthService() {
    user = Observable(_auth.onAuthStateChanged);

    profile = user.switchMap((FirebaseUser u) {
      if (u != null) {
        return _db
            .collection("user")
            .document(u.uid)
            .snapshots()
            .map((snap) => snap.data);
      } else {
        return Observable.just({});
      }
    });
  }

  Future<FirebaseUser> googleSignIn() async {
    loading.add(true);
    try {
      googleUser = await _googleSignIn.signIn();
      User.instance.googleSignIn = googleUser;
    } catch (error) {
      print(error);
    }

    print("SignIn done");
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    print("Auth done");

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print("AuthCred done");

    final FirebaseUser user = await _auth.signInWithCredential(credential);
    User.instance.firebaseAuth = _auth;
    print("signed in " + user.displayName);

    updateUserData(user);
  }

  void updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection("users").document(user.uid);

    // Need to check if user already exists. If not, set picture wins to 0
    final QuerySnapshot result = await Firestore.instance
        .collection('users')
        .where('uid', isEqualTo: user.uid)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length <= 0) {
      List<Timestamp> tempTime = new List<Timestamp>();
      ref.setData({
        'visitedGames': tempTime,
        'acceptedTerms': false,
        'pictureWins': 0,
        'lastSeen': DateTime.now(),
      }, merge: true);
    }

    int imageVotes; //probably old code
    int playerVotes; //also probably old
    User.instance.displayName = user.displayName;
    User.instance.email = googleUser.email;
    User.instance.uid = user.uid;
    User.instance.getVisitedGamesFromDB();
    User.instance.getPictureWins(ref);

    ref.get().then((DocumentSnapshot ds) {
      Timestamp lastSeenFromDataBase = ds['lastSeen'];

      DateTime startOfToday = DateTime.now();
      startOfToday = DateTime(
          startOfToday.year, startOfToday.month, startOfToday.day, 0, 0, 0, 0);
      DateTime lastSeen = lastSeenFromDataBase.toDate();
      print("lastSeen: " + lastSeen.toString());

      if (lastSeen.isAfter(startOfToday)) {
        playerVotes = 1;
        imageVotes = 1;
        User.instance.pictureAddedForCompetition = false;
        User.instance.playerVotes = 1;
        User.instance.imageVotes = 1;
      } else {
        playerVotes = 0;
        imageVotes = 0;
        User.instance.pictureAddedForCompetition = true;
        User.instance.playerVotes = 0;
        User.instance.imageVotes = 0;
      }
      ref.setData({
        'uid': user.uid,
        'email': googleUser.email,
        'playerVotes': playerVotes,
        'imageVotes': imageVotes,
        'picturesAddedForCompetition': false,

        //These may be unnecessary :D
        'photoUrl': user.photoUrl,
        'displayName': user.displayName,
        'lastSeen': DateTime.now(),
        'phoneNumber': user.phoneNumber
      }, merge: true);

      User.instance.hasAcceptedTerms = ds['acceptedTerms'];
      User.instance.hasLoadedUser = true; // Userdata has been loaded.
    });

    print("Kirjautuu");
  }

  void signOut() async {
    // Firebase sign out
    await _auth.signOut();

    // Google sign out
    await _googleSignIn.signOut();
  }

  void deleteUser() async {
    // Firebase sign out
    await _auth.signOut();

    // Google sign out
    await _googleSignIn.signOut();

    await Firestore.instance
        .collection('users')
        .where('uid', isEqualTo: User.instance.uid)
        .limit(1)
        .getDocuments()
        .then((val) {
      val.documents[0].reference.delete();
    });

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    user.delete();
  }
}

final AuthService authService = AuthService();

class UserProfile extends StatefulWidget {
  @override
  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  Map<String, dynamic> _profile;
  bool _loading = false;

  @override
  initState() {
    super.initState();

    // Subscriptions are created here
    authService.profile.listen((state) => setState(() => _profile = state));

    authService.loading.listen((state) => setState(() => _loading = state));
  }

  @override
  Widget build(BuildContext context) {
    //print(_profile);
    return Column(children: <Widget>[
      Container(
          padding: EdgeInsets.all(20),
          child: Text(
            this.profileName(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          )),
      //Text(_loading.toString())
    ]);
  }

  String profileName() {
    if (_profile.toString() == "{}")
      return "Et ole vielä kirjautunut sisään.";
    else
      return "Kirjauduttu käyttäjällä:\n" + User.instance.displayName;
  }
}

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: authService.user,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: <Widget>[
              MaterialButton(
                  onPressed: () {
                    if(!User.instance.hasAcceptedTerms)
                    {
                      termsPopUp(context, "TermsTextii", function:(){Navigation.openStartPage(context);});
                    }
                    else
                    {
                      Navigation.openStartPage(context);
                    }
                  },
                  color: Colors.green,
                  textColor: Colors.black,
                  child: Text("Jatka käyttäjällä")),
              MaterialButton(
                  onPressed: () {
                    authService.signOut();
                  },
                  color: Colors.red,
                  textColor: Colors.black,
                  child: Text("Kirjaudu ulos")),
            ],
          );
        } else {
          return Column(
            children: <Widget>[
              MaterialButton(
                onPressed: () => authService.googleSignIn(),
                color: Colors.white54,
                textColor: Colors.black,
                child: Text("Kirjaudu sisään Google tilillä"),
              ),
            ],
          );
        }
      },
    );
  }

}

class MaterialStartPage extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    return MaterialApp(
      theme: MasterTheme.mainTheme,
      home: StartPageForm(),
    );
  }
}
