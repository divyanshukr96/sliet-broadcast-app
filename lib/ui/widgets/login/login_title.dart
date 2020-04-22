import 'package:flutter/material.dart';
import 'package:sliet_broadcast/style/theme.dart' as Theme;

class LoginTitle extends StatelessWidget {
  const LoginTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250.0,
      height: 40.0,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 5.0,
            spreadRadius: 1.0,
            offset: Offset(1.0, 1.0),
          )
        ],
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(28.0)),
      ),
      child: CustomPaint(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'SLIET Broadcast',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.w500,
                fontFamily: 'Montserrat',
                foreground: Paint()..shader = Theme.Colors.primaryTextGradient,
              ),
            )
          ],
        ),
      ),
    );
  }
}


