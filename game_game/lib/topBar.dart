import 'package:flutter/material.dart';
import 'package:flutter_testuu/mainMenuAtTop.dart';

topBar(BuildContext context, String pageTitle) {
  return Align(
    alignment: Alignment.topCenter,
    child: Padding(
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          NavBar(),
          Text(
            pageTitle,
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.title,
          ),
        ],
      ),
    ),
  );
}
