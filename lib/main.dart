import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliet_broadcast/provider_setup.dart';
import 'package:sliet_broadcast/ui/screen/home_screen.dart';
import 'package:sliet_broadcast/ui/routes.dart';
import 'package:sliet_broadcast/ui/screen/splashing_screeen.dart';
import 'package:sliet_broadcast/utils/app_upgrader.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashingScreen(),
        routes: {
          '/start': (context) => AppUpgrade(child: HomeScreen()),
          '/home': (context) => HomeScreen(),
        },
        onGenerateRoute: Router.generateRoute,
      ),
      providers: providers,
    );
  }
}
