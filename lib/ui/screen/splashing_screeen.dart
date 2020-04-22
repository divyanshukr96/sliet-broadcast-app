import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashingScreen extends StatelessWidget {
  const SplashingScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      navigateAfterSeconds: '/start',
      title: new Text(
        'Together we can make a difference',
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
      ),
      image: Image.asset('assets/images/splash_screen.png'),
      backgroundColor: Colors.white,
      photoSize: 90.0,
    );
  }
}
