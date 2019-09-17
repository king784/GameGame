class ImageFromDB {
  String photographerName;
  String imgUrl;
  String downloadUrl;
  int totalVotes;
  String dateTaken;
  bool isWinning = false;

  ImageFromDB(this.photographerName, this.imgUrl, this.downloadUrl,
      this.totalVotes, this.dateTaken, {this.isWinning});

  @override
  String toString() {
    return "$photographerName, $imgUrl, $downloadUrl, $totalVotes, $dateTaken., $isWinning";
  }

  ImageFromDB.fromJson(Map<String, dynamic> json)
      : dateTaken = json['dateTaken'],
        downloadUrl = json['downloadUrl'],
        imgUrl = json['imgUrl'],
        photographerName = json['photographerName'],
        totalVotes = json['totalVotes'],
        isWinning = json['isWinning'];

  Map<String, dynamic> toJson() => {
        'photographerName': photographerName,
        'imgUrl': imgUrl,
        'downloadUrl': downloadUrl,
        'totalVotes': totalVotes,
        'isWinning': isWinning
      };
}
