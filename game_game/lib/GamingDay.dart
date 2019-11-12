import 'package:cloud_firestore/cloud_firestore.dart';

class GamingDay {
  // ImageVotes instance, we need only 1 that we can access
  GamingDay.gamingDayPrivate();

  static final GamingDay _instance = GamingDay.gamingDayPrivate();

  static GamingDay get instance {
    return _instance;
  }

  DateTime gamingDay;

  bool gameDay = false;
  bool gameDayHasBeenChecked = false;

  // If gameday hasn't been checked, this function checks it.
  void IsGameDay()
  {
    if(!gameDayHasBeenChecked)
    {
      getCompetitionDay();
    }
  }

  //check if today's a game day
  Future<void> getCompetitionDay() async {
    //check if the competition is on
    final QuerySnapshot result =
        await Firestore.instance //get the gaing day collection from firebase
            .collection('gamingDay')
            .limit(1) //limits documents to one
            .getDocuments();
    Timestamp gamingDayTS =
        result.documents[0]['activeDay']; //convert the gotten value to date
    gamingDay = gamingDayTS.toDate();
    //print("Game day: " +gamingDay.toDate().toString() +", today is: " + DateTime.now().toString());

    if (areDatesSame(gamingDay, DateTime.now())) {
      //check agains today
      gameDay = true;
    }

    gameDayHasBeenChecked = true;
  }

  bool areDatesSame(DateTime first, DateTime second) {
    if (first.year == second.year) {
      if (first.month == second.month) {
        if (first.day == second.day) {
          return true;
        }
      }
    }
    return false;
  }
}