import 'package:flutter_testuu/Globals.dart';

class User {
  String displayName;
  String email;
  bool VIP;
  bool bannedFromChat;
  int watchedGames;
  int maxVotes, playerVotes, imageVotes;
  List<VisitedGame> visitedGames = new List<VisitedGame>();

  User(String username, String newEmail, bool vip) {
    this.displayName = username;
    this.email = email;
    this.VIP = vip;
    this.bannedFromChat = false;
    this.watchedGames = 0;

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

  void updateVotes(){
    this.imageVotes = this.maxVotes;
    this.playerVotes = this.maxVotes;
  }
}
