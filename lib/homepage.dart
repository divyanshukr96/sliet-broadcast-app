import 'package:flutter/material.dart';
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

  final _controller = PageController();
  int _index = 0;

  dynamic _pageOptions = <Widget>[PublicFeed()];

  _HomePageState() {
    _controller.addListener(() {
      if (_controller.page.round() != _index) {
        setState(() {
          _index = _controller.page.round();
        });
      }
    });
  }

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
    if (["DEPARTMENT", "SOCIETY", "CHANNEL"].contains(userType)) {
      await _pageOptions.add(CreateNotice());
    }
    if (["FACULTY"].contains(userType)) {
      await _pageOptions.add(PrivateFeed());
    }
    if (["DEPARTMENT", "SOCIETY", "CHANNEL"].contains(userType)) {
      await _pageOptions.add(PublishedNotice());
    }
  }

  void _showPageIndex(int index) {
    setState(() {
      _index = index;
    });
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('SLIET Broadcast'),
      ),
      body: PageView(
        controller: _controller,
        children: _pageOptions,
      ),
      drawer: HomeDrawer(),
      bottomNavigationBar: authenticated &&
              ["FACULTY", "DEPARTMENT", "SOCIETY", "CHANNEL"].contains(userType)
          ? buildBottomNavigationBar()
          : null,
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    List<BottomNavigationBarItem> items = new List<BottomNavigationBarItem>();
    items.add(BottomNavigationBarItem(
      icon: Icon(Icons.public),
      title: Text('Public'),
    ));
    if (["DEPARTMENT", "SOCIETY", "CHANNEL"].contains(userType)) {
      items.add(BottomNavigationBarItem(
        icon: Icon(Icons.add_circle_outline),
        title: Text('Add Notice'),
      ));
    }
    if (["FACULTY"].contains(userType)) {
      items.add(BottomNavigationBarItem(
        icon: Icon(Icons.vpn_key),
        title: Text('Private'),
      ));
    }
    if (["DEPARTMENT", "SOCIETY", "CHANNEL"].contains(userType)) {
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
