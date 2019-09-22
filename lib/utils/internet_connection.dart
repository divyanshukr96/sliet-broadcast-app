import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:sliet_broadcast/utils/internet_status_bar.dart';

class InternetConnection extends StatefulWidget {
  @override
  _InternetConnectionState createState() => _InternetConnectionState();
}

class _InternetConnectionState extends State<InternetConnection> {
  StreamSubscription connectivitySubscription;

  ConnectivityResult _previousResult;

  bool _internet = true;

  @override
  void initState() {
    super.initState();

    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) {
      if (connectivityResult == ConnectivityResult.none) {
        setState(() {
          _internet = false;
        });
      } else if (_previousResult == ConnectivityResult.none) {
        setState(() {
          _internet = true;
        });
      }

      _previousResult = connectivityResult;
    });
  }

  @override
  void dispose() {
    super.dispose();
    connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    print(_internet);
    return InternetStatusBar(_internet);
  }
}
