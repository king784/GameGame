import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PictureCardList extends StatefulWidget {
  @override
  _PictureCardListState createState() => _PictureCardListState();
}

class _PictureCardListState extends State<PictureCardList> {
  List<imageFromDB> allimages = new List<imageFromDB>();
  @override
  Widget build(BuildContext context) {
    return Text("working on this");
  }

  _cardWithPic(String photographersUsername, String imgUrl, int votes) {
    return Card(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: imgUrl,
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(
                      'Saadut äänet:',
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.body1,
                    ),
                    Text(
                      votes.toString(),
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.subhead,
                    ),
                    RaisedButton(
                      child: Icon(FontAwesomeIcons.plus),
                      onPressed: () => {},
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class imageFromDB {
  String photographerName;
  int totalVotes;
  String imgUrl;

  imageFromDB() {}
}
