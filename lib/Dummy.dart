import 'dart:async';

import 'package:flutter/material.dart';

import 'package:sliet_broadcast/style/theme.dart' as Theme;



class Dummy extends StatefulWidget {



  @override
  _DummyState createState() => _DummyState();
}

class _DummyState extends State<Dummy> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(Duration(seconds: 3), () {
      Navigator.pop(context);
    });


  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        Navigator.pop(context);
      },
      child: Container(
        height: MediaQuery.of(context).size.height,
        width:  MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              // Where the linear gradient begins and ends
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Theme.Colors.loginGradientEnd,
                Theme.Colors.loginGradientStart,
              ],

            )
        ),
        child: CircularProgressIndicator(),
      ),
    );
  }



}
