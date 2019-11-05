import 'package:flutter/material.dart';
import 'mainMenuAtTop.dart';

topBar(BuildContext context, String pageTitle) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: <Widget>[
      NavBar(),
      Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          pageTitle,
          textAlign: TextAlign.right,
          style: Theme.of(context).textTheme.title,
        ),
      ),
    ],
  );
}
