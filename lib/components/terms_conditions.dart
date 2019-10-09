import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TermsAndConditions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var style = TextStyle(
      fontSize: 18.0,
      height: 1.5,
      fontStyle: FontStyle.italic,
      fontFamily: 'WorkSansSemiBold',
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms and conditions'),

      ),
      body: Container(
        margin: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                '✎ This application is for official communication inside SLIET, Longowal campus.',
                textAlign: TextAlign.justify,
                style: style,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                '✎ The ACSS Section, SLIET Longowal is the administrator of this application.',
                textAlign: TextAlign.justify,
                style: style,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                '✎ All activities and communication on the platform is monitored by the administrator. If any sort of wrong communication is done through the platform, the administrator has the right to take strict action against the user responsible for doing so.',
                textAlign: TextAlign.justify,
                style: style,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                '✎ Administration channels in the platform cannot be unfollowed by any user.',
                textAlign: TextAlign.justify,
                style: style,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                '✎ The user accounts will be activated only after they have been verified.',
                textAlign: TextAlign.justify,
                style: style,
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'SLIET Broadcast',
                textAlign: TextAlign.center,
                style: style,
                textScaleFactor: 1.5,
              ),
            ),
            Text(
              '- - - - - - - - - - - - - - - - - - - -',
              textAlign: TextAlign.center,
              style: style,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: FlatButton(
                splashColor: Colors.lightBlue,
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Back",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 18.0,
                    fontFamily: "WorkSansMedium",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
