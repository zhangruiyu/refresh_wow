import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SnackBarUtils {
  static void showSnackBar(ScaffoldState scaffoldState, String text,
      {bool isSuccess = true, dynamic listener}) {
    scaffoldState.showSnackBar(new SnackBar(
        content: new Text(text),
        backgroundColor: isSuccess
            ? Theme.of(scaffoldState.context).accentColor
            : Theme.of(scaffoldState.context).errorColor));
    new Timer(new Duration(milliseconds: 1500), () {
      if (scaffoldState.widget != null && listener != null) {
        listener();
      }
    });
  }
}
