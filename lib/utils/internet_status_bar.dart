import 'package:flutter/material.dart';

class InternetStatusBar extends StatelessWidget {
  bool internet;

  InternetStatusBar(this.internet);

  @override
  Widget build(BuildContext context) {
    if (!internet)
      return Container(
        height: 32.0,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.red,
        ),
        child: Center(
          child: Text(
            'NO INTERNET CONNECTION',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    else {
      return SizedBox(height: 0.0);
    }
  }
}
