import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliet_broadcast/components/profile.dart';
import 'package:sliet_broadcast/homepage.dart';
import 'package:sliet_broadcast/provider/bookmarkNoticeNotifier.dart';
import 'package:sliet_broadcast/provider/interestedNoticeNotifier.dart';
import 'package:sliet_broadcast/provider/privateNoticeNotifier.dart';
import 'package:sliet_broadcast/provider/publicNoticeNotifier.dart';
import 'package:sliet_broadcast/utils/app_upgrader.dart';
import 'package:splashscreen/splashscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashingHome(),
//      initialRoute: '/',
        routes: {
//        '/': (context) => SplashingHome(),
          '/home': (context) => AppUpgrade(child: HomePage()),
          '/profile': (context) => Profile(),
        },
      ),
      providers: <SingleChildCloneableWidget>[
        ChangeNotifierProvider(
          builder: (_) => PublicNoticeNotifier(),
        ),
        ChangeNotifierProvider(
          builder: (_) => PrivateNoticeNotifier(),
        ),
        ChangeNotifierProvider(
          builder: (_) => BookmarkNoticeNotifier(),
        ),
        ChangeNotifierProvider(
          builder: (_) => InterestedNoticeNotifier(),
        ),
      ],
    );
  }
}

class SplashingHome extends StatelessWidget {
  const SplashingHome({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 4,
      navigateAfterSeconds: '/home',
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
