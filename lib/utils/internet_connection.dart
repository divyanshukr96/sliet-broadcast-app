import 'package:flutter/material.dart';

class InterNetConnection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.red,
      ),
      child:Text('internet nahi hai madarchod'),
    );
  }
}
