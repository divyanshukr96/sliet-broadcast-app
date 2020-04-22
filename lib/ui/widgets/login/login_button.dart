import 'package:flutter/material.dart';
import 'package:sliet_broadcast/ui/routes.dart';

class NewAccountButton extends StatelessWidget {
  const NewAccountButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                // TODO focusNode not clear
                Navigator.pushNamed(context, RoutePath.Register);
              },
              child: Text(
                'Register',
                style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LoginBackButton extends StatelessWidget {
  const LoginBackButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 35.0,
      left: 10.0,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                left: 0,
                top: 10,
                bottom: 10,
              ),
              child: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.white,
              ),
            ),
            Text(
              'Back',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
