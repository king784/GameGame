import 'user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferences
{
  addUserToSP(User newUser) async 
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('displayName', newUser.displayName);
    prefs.setString('email', newUser.email);
    prefs.setString('uid', newUser.uid);
    prefs.setBool('VIP', newUser.VIP);
    prefs.setBool('bannedFromChat', newUser.bannedFromChat);
    prefs.setBool('pictureAddedForCompetition', newUser.pictureAddedForCompetition);
    prefs.setInt('watchedGames', newUser.watchedGames);
    prefs.setInt('maxVotes', newUser.maxVotes);
    prefs.setInt('playerVotes', newUser.playerVotes);
    prefs.setInt('imageVotes', newUser.imageVotes);
    prefs.setInt('pictureWins', newUser.pictureWins);
    // Loop datetimes
  }

  // String displayName = "";
  // String email;
  // String uid;
  // bool VIP;
  // bool bannedFromChat;
  // bool pictureAddedForCompetition;
  // int watchedGames;
  // int maxVotes, playerVotes, imageVotes;
  // int pictureWins;
  // List<DateTime> visitedGames = new List<DateTime>();

  getUserFromSP() async 
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('intValue', 123);
  }
}
