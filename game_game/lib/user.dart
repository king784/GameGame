class User {
  String Username;
  bool VIP;
  bool bannedFromChat;
  int watchedGames;
  int maxVotes, playerVotes, imageVotes;

  User(String username, bool vip) {
    this.Username = username;
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
