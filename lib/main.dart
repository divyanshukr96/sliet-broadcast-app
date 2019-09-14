import 'package:flutter/material.dart';
import './components/noticeCard.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return
      MaterialApp(
       home:Scaffold(
         appBar: AppBar(),
         body: NoticeCard(),
       ),
      );

  }
}


