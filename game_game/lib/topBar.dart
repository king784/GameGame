import 'package:flutter/material.dart';
import 'package:flutter_testuu/radialMenu.dart';

topBar(BuildContext context, String pageTitle) {
  return Align(
    alignment: Alignment.topCenter,
    child: Padding(
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RadialMenu(),
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
