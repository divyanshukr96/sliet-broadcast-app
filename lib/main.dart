import 'package:flutter/material.dart';
import 'package:sliet_broadcast/homepage.dart';
import 'package:sliet_broadcast/login.dart';
import './components/noticeCard.dart';
import './style/theme.dart' as Theme;

import './components/drawerItem.dart';
import './publicFeed.dart';
import './createNotice.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }


}
