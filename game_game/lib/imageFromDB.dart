class ImageFromDB {
  String photographerName;
  String imgUrl;
  String downloadUrl;
  int totalVotes;
  String dateTaken;

  ImageFromDB(this.photographerName, this.imgUrl, this.downloadUrl,
      this.totalVotes, this.dateTaken);

  @override
  String toString() {
    return "$photographerName, $imgUrl, $downloadUrl, $totalVotes, $dateTaken.";
  }

  Map<String, dynamic> toJson() => {
        'photographerName': photographerName,
        'imgUrl': imgUrl,
        'downloadUrl': downloadUrl,
        'totalVotes': totalVotes
      };
}
