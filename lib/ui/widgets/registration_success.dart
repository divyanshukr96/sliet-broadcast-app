import 'package:flutter/material.dart';
import 'package:sliet_broadcast/style/theme.dart' as Theme;
import 'package:sliet_broadcast/ui/routes.dart';

class RegistrationSuccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Theme.Colors.loginGradientEnd,
            Theme.Colors.loginGradientStart,
          ],
        ),
      ),
      child: SafeArea(
        child: Card(
          color: Colors.transparent,
          margin: EdgeInsets.all(8.0),
//          elevation: 5.0,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 120.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/splash_screen.png'),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Thank you for registering with us.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Your account will be activated after your details have been verified by the Administrator.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17.0,
                      color: Colors.white70,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'It may take some time for the verification to complete.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white60,
                    ),
                  ),
                ),
                SizedBox(height: 24.0),
                FlatButton(
                  splashColor: Colors.lightBlue,
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      RoutePath.TermsConditions,
                    );
                  },
                  child: Text(
                    "Read terms and conditions",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white54,
                      decoration: TextDecoration.underline,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                SizedBox(height: 24.0),
                FlatButton(
                  splashColor: Colors.lightBlue,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Back",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
