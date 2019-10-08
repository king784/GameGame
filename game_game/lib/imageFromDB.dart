class ImageFromDB {
  String photographerName;
  String photographerID;
  String imgUrl;
  String downloadUrl;
  int totalVotes;
  String dateTaken;
  bool isWinning = false;

  ImageFromDB(this.photographerName,this.photographerID, this.imgUrl, this.downloadUrl,
      this.totalVotes, this.dateTaken, {this.isWinning});

  @override
  String toString() {
    return "$photographerName,$photographerID, $imgUrl, $downloadUrl, $totalVotes, $dateTaken., $isWinning";
  }

  ImageFromDB.fromJson(Map<String, dynamic> json)
      : dateTaken = json['dateTaken'],
        downloadUrl = json['downloadUrl'],
        imgUrl = json['imgUrl'],
        photographerName = json['photographerName'],
        photographerID = json['photographerID'],
        totalVotes = json['totalVotes'],
        isWinning = json['isWinning'];

  Map<String, dynamic> toJson() => {
        'photographerName': photographerName,
        'photographerID': photographerID,
        'imgUrl': imgUrl,
        'downloadUrl': downloadUrl,
        'totalVotes': totalVotes,
        'isWinning': isWinning
      };
}
