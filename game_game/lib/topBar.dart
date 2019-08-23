import 'package:flutter/material.dart';
import 'package:flutter_testuu/radialMenu.dart';

topBar(BuildContext context, String pageTitle) {
  Align(
    alignment: Alignment.topCenter,
    child: Row(
      children: <Widget>[
        RadialMenu(),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
             pageTitle,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.title,
            ),
          ),
        )
      ],
    ),
  );
}
