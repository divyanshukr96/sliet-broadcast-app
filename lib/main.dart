import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliet_broadcast/components/channel_details.dart';
import 'package:sliet_broadcast/components/profile.dart';
import 'package:sliet_broadcast/homepage.dart';
import 'package:sliet_broadcast/login.dart';
import 'package:sliet_broadcast/provider/provider_setup.dart';
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
        routes: {
          '/start': (context) => AppUpgrade(child: HomePage()),
          '/home': (context) => HomePage(),
          '/profile': (context) => Profile(),
          '/login': (context) => LoginPage(),
        },
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (BuildContext context) {
              switch (settings.name) {
                case '/details':
                  return ChannelDetail(settings.arguments);
                default:
                  throw 'Route ${settings.name} is not defined';
              }
            },
            maintainState: true,
            fullscreenDialog: false,
          );
        },
      ),
      providers: providers,
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
