import 'package:flutter/material.dart';
import 'package:sliet_broadcast/homepage.dart';
import 'package:splashscreen/splashscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(
        seconds: 4,
        navigateAfterSeconds: HomePage(),
        title: new Text('Together we can make a difference',
          style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0
          ),
        ),
        image:  Image.asset('assets/images/splash_screen.png'),
        //backgroundGradient: new LinearGradient(colors: [Colors.cyan, Colors.blue], begin: Alignment.topLeft, end: Alignment.bottomRight),
        backgroundColor: Colors.white,
        //styleTextUnderTheLoader: new TextStyle(),
        photoSize: 90.0,
        //onClick: ()=>print("Flutter Egypt"),
        //loaderColor: Colors.red,
      ),
    );
  }
}
