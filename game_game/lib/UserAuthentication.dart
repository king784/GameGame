import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import 'Themes/MasterTheme.dart';

void main() => runApp(UserAuthentication());

class UserAuthentication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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

              MaterialButton(
                onPressed: () => authService.googleSignIn(),
                color: Colors.white54,
                textColor: Colors.black,
                child: Text("Kirjaudu sisään Google tilillä"),
              ),

              MaterialButton(
                onPressed: () => authService.signOut(),
                color: Colors.red,
                textColor: Colors.black,
                child: Text("Poistu"),
              )
            ],
          ),
        ),
      ),
      
    );
  }
}


class AuthService{
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  Observable<FirebaseUser> user;
  Observable<Map<String, dynamic>> profile;
  PublishSubject loading = PublishSubject();

  AuthService(){
    user = Observable(_auth.onAuthStateChanged);

    profile = user.switchMap(
      (FirebaseUser u){
        if(u != null){
          return _db.collection("user").document(u.uid).snapshots().map((snap) => snap.data);
        }
        else{
          return Observable.just({});
        }
      }
    );
  }

  Future<FirebaseUser> googleSignIn() async {
    print("1");
    loading.add(true);
    print("2");
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    print("3");
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    print("4");


    final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,

    );

    final FirebaseUser user = await _auth.signInWithCredential(credential);
    print("signed in " + user.displayName);

    updateUserData(user);

  }

  void updateUserData(FirebaseUser user) async{
    DocumentReference ref = _db.collection("users").document(user.uid);

    return ref.setData({
      'uid': user.uid,
      'email': user.email,

      //These may be unnecessary :D
      'photoUrl': user.photoUrl,
      'displayName': user.displayName,
      'lastSeen': DateTime.now(),
      'phoneNumber': user.phoneNumber
    }, merge: true);
  }

  void signOut(){
    _auth.signOut();
  }
}

final AuthService authService = AuthService();

