import 'package:flutter/material.dart';
import 'package:sliet_broadcast/createNotice.dart';
import 'package:sliet_broadcast/home_drawer.dart';
import 'package:sliet_broadcast/publicFeed.dart';
import 'package:sliet_broadcast/utils/internet_connection.dart';
import 'package:sliet_broadcast/utils/network_utils.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NetworkUtils networkUtils = new NetworkUtils();
  bool authenticated = false;
  String userType = "STUDENT";

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
    networkUtils.getUserType().then((onValue) {
      setState(() {
        userType = onValue;
      });
    });

    super.initState();
    _selectedTab = 0;
    _pageOptions = [PublicFeed()];
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
      bottomNavigationBar: authenticated &&
              ["FACULTY", "DEPARTMENT", "SOCIETY"].contains(userType)
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

    if (["DEPARTMENT", "SOCIETY"].contains(userType)) {
      _pageOptions.add(CreateNotice());
      items.add(BottomNavigationBarItem(
        icon: Icon(Icons.add_circle_outline),
        title: Text('Add Notice'),
      ));
    }

    _pageOptions.add(PublicFeed());
    items.add(BottomNavigationBarItem(
      icon: Icon(Icons.vpn_key),
      title: Text('Private'),
    ));

    return BottomNavigationBar(
      currentIndex: _selectedTab,
      onTap: (int index) {
        setState(() {
          _selectedTab = index;
          currentPage = _pageOptions[index];
        });
      },
      items: items,
    );
  }

  Widget getWidget(int index) {
    print(_pageOptions[index]);
    return _pageOptions[index];
  }
}
