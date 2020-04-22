import 'package:flutter/material.dart';

class SnackBarView {
  static show(GlobalKey<ScaffoldState> scaffoldKey, String message) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        message ?? 'You are offline',
        textAlign: TextAlign.center,
      ),
    ));
  }
}
