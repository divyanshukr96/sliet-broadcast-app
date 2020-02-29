import 'package:flutter/material.dart';
import 'package:sliet_broadcast/components/notification.dart';
import 'package:sliet_broadcast/createNotice.dart';
import 'package:sliet_broadcast/home_drawer.dart';
import 'package:sliet_broadcast/privateFeed.dart';
import 'package:sliet_broadcast/publicFeed.dart';
import 'package:sliet_broadcast/published_notice.dart';
import 'package:sliet_broadcast/utils/network_utils.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NetworkUtils networkUtils = new NetworkUtils();
  bool authenticated = false;
  String userType = "STUDENT";

  int _index = 0;

  final List<Widget> _pageOptions = <Widget>[PublicFeed()];

  @override
  void initState() {
    networkUtils.isAuthenticated().then((onValue) {
      setState(() {
        authenticated = onValue;
      });
    });
    _pageViewAdd();
    super.initState();
  }

  void _pageViewAdd() async {
    await networkUtils.getUserType().then((onValue) {
      setState(() {
        userType = onValue;
      });
    });
  }

  void _showPageIndex(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('SLIET Broadcast'),
      ),
      body: _pageOptions[_index],
      drawer: HomeDrawer(),
      bottomNavigationBar: authenticated ? buildBottomNavigationBar() : null,
//      bottomNavigationBar: authenticated &&
//              ["FACULTY", "DEPARTMENT", "SOCIETY", "CHANNEL"].contains(userType)
//          ? buildBottomNavigationBar()
//          : null,
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    List<BottomNavigationBarItem> items = new List<BottomNavigationBarItem>();
    items.add(BottomNavigationBarItem(
      icon: Icon(Icons.public),
      title: Text('Public'),
    ));
    if (["DEPARTMENT", "SOCIETY", "CHANNEL"].contains(userType)) {
      _pageOptions.add(CreateNotice());
      items.add(BottomNavigationBarItem(
        icon: Icon(Icons.add_circle_outline),
        title: Text('Add Notice'),
      ));
    }
    if (["STUDENT"].contains(userType)) {
      _pageOptions.add(PrivateFeed());
      items.add(BottomNavigationBarItem(
        icon: Icon(Icons.subject),
        title: Text('My Notice'),
      ));
    }
    if (["FACULTY"].contains(userType)) {
      _pageOptions.add(PrivateFeed());
      items.add(BottomNavigationBarItem(
        icon: Icon(Icons.vpn_key),
        title: Text('Private'),
      ));
    }
    if (["DEPARTMENT", "SOCIETY", "CHANNEL"].contains(userType)) {
      _pageOptions.add(PublishedNotice());
      items.add(BottomNavigationBarItem(
        icon: Icon(Icons.publish),
        title: Text('Published'),
      ));
    }
    return BottomNavigationBar(
      currentIndex: _index,
      onTap: (int index) => _showPageIndex(index),
      items: items,
    );
  }
}
