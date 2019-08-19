class ImageFromDB {
  String photographerName;
  String imgUrl;
  String downloadUrl;
  int totalVotes;

  ImageFromDB(
      this.photographerName, this.imgUrl, this.downloadUrl, this.totalVotes);

  @override
  String toString() {
    return "$photographerName $imgUrl $downloadUrl $totalVotes";
  }

  Map<String, dynamic> toJson() => {
        'photographerName': photographerName,
        'imgUrl': imgUrl,
        'downloadUrl': downloadUrl,
        'totalVotes': totalVotes
      };
}