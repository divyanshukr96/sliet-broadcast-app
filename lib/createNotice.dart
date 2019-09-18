import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;

import 'package:sliet_broadcast/style/theme.dart' as Theme;


class CreateNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.Colors.loginGradientEnd,
              Theme.Colors.loginGradientStart,
            ],
          ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

        ],
      ),
    );
  }
}
