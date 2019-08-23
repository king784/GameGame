import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_testuu/Navigation.dart';
import 'package:flutter_testuu/pages/startPage.dart';
import 'package:flutter_testuu/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import 'Themes/MasterTheme.dart';
import 'StartPageForm.dart';
import 'pages/main.dart';

void main() => runApp(UserAuthentication());

class UserAuthentication extends StatelessWidget {
  bool firstTime = false;

  @override
  Widget build(BuildContext context) {
    if(!firstTime)
    {
      User user = User.instance;
      firstTime = true;
    }
    // TODO: implement build
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

              //MaterialButton(
              //  onPressed: () => authService.googleSignIn(),
              //  color: Colors.white54,
              //  textColor: Colors.black,
              //  child: Text("Kirjaudu sisään Google tilillä"),
              //),

              //MaterialButton(
              //  onPressed: () => authService.signOut(),
              //  color: Colors.red,
              //  textColor: Colors.black,
              //  child: Text("Poistu"),
              //)
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
    try
    {
      googleUser = await _googleSignIn.signIn();
    } catch(error)
    {
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
    print("signed in " + user.displayName);

    updateUserData(user);
  }

  void updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection("users").document(user.uid);

    User.instance.displayName = user.displayName;
    User.instance.email = googleUser.email;
    User.instance.uid = user.uid;

    return ref.setData({
      'uid': user.uid,
      'email': googleUser.email,

      //These may be unnecessary :D
      'photoUrl': user.photoUrl,
      'displayName': user.displayName,
      'lastSeen': DateTime.now(),
      'phoneNumber': user.phoneNumber
    }, merge: true);
  }

  void signOut() {
    _auth.signOut();
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
    print(_profile);
    return Column(children: <Widget>[
      Container(
          padding: EdgeInsets.all(20),
          child: Text(this.profileName(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20
          ),
          )
          ),
      //Text(_loading.toString())
    ]);
  }

  String profileName(){
    if(_profile.toString() == "{}")
      return "Et ole vielä kirjautunut sisään.";
    else
      return "Kirjauduttu käyttäjällä:\n" + _profile.toString();
  }
}

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
          return StreamBuilder(
        stream: authService.user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: <Widget>[

                MaterialButton(
                  onPressed: (){ 
                    //Navigation.openStartPage(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp()),
                );
                  
                  },
                    color: Colors.green,
                    textColor: Colors.black,
                    child: Text("Jatka käyttäjällä")),

                MaterialButton(
                  onPressed: () => authService.signOut(),
                    color: Colors.red,
                    textColor: Colors.black,
                    child: Text("Kirjaudu ulos")),

              ],
            );
          } else {
            return MaterialButton(
              onPressed: () => authService.googleSignIn(),
              color: Colors.white54,
              textColor: Colors.black,
              child: Text("Kirjaudu sisään Google tilillä"),
            );
          }
        },
    );
  }
}
class MaterialStartPage extends StatelessWidget
{
  @override
  Widget build(BuildContext ctx)
  {
    return MaterialApp(theme: MasterTheme.mainTheme,
    home: StartPageForm(),);
  }
}