import 'package:flutter/material.dart';
import 'package:sliet_broadcast/home_drawer.dart';
import 'package:sliet_broadcast/publicFeed.dart';
import 'package:sliet_broadcast/utils/internet_connection.dart';
import 'package:sliet_broadcast/utils/network_utils.dart';

import 'createNotice.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NetworkUtils networkUtils = new NetworkUtils();
  bool authenticated = false;

  int _selectedTab;
  Widget currentPage;

  List<Widget> _pageOptions;

  @override
  void initState() {
    networkUtils.isAuthenticated().then((onValue) {
      setState(() {
        authenticated = onValue;
      });
    });

    super.initState();
    _selectedTab = 0;
    _pageOptions = [
      PublicFeed(),
      CreateNotice(),
      PublicFeed(),
    ];
    currentPage = PublicFeed();
  }

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
            currentPage,
          ],
        ),
      ),
      drawer: HomeDrawer(),
      bottomNavigationBar: authenticated ? buildBottomNavigationBar() : null,
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedTab,
      onTap: (int index) {
        setState(() {
          _selectedTab = index;
          currentPage = _pageOptions[index];
          print(
              ":::::::::::::::::::::::::::::::::::::::::   on Bottom navigationbar      homepage.dart");
          print(_selectedTab);
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.public),
          title: Text('Public'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          title: Text('Add Notice'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.vpn_key),
          title: Text('Private'),
        ),
      ],
    );
  }

  Widget getWidget(int index) {
    print(_pageOptions[index]);
    return _pageOptions[index];
  }
}
