import 'package:flutter/material.dart';
import 'package:sliet_broadcast/createNotice.dart';
import 'package:sliet_broadcast/home_drawer.dart';
import 'package:sliet_broadcast/publicFeed.dart';
import 'package:sliet_broadcast/utils/internet_connection.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('SLIET Broadcast'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            InternetConnection(),
//            PublicFeed(),
            CreateNotice(),
          ],
        ),
      ),
      drawer: HomeDrawer(),
    );
  }
}
