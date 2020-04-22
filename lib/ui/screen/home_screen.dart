import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliet_broadcast/core/models/user.dart';
import 'package:sliet_broadcast/core/services/authenticationService.dart';
import 'package:sliet_broadcast/ui/pages/private_notice.dart';
import 'package:sliet_broadcast/ui/pages/public_notice.dart';
import 'package:sliet_broadcast/ui/pages/published_notice.dart';
import 'package:sliet_broadcast/ui/screen/notice_create_screen.dart';
import 'package:sliet_broadcast/ui/widgets/home_drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  User authUser = User();
  int _index = 0;

  final List<Widget> _pageOptions = <Widget>[
    PublicNotice(),
  ];

  void _showPageIndex(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: Provider.of<AuthenticationService>(context).user,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data != null) {
          authUser = snapshot.data;
        }
        return Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text('SLIET Broadcast'),
          ),
          body: _pageOptions[_index],
          drawer: HomeDrawer(authUser),
          bottomNavigationBar:
              authUser.id != null ? buildBottomNavigationBar(context) : null,
        );
      },
    );
  }

  BottomNavigationBar buildBottomNavigationBar(BuildContext context) {
    List<BottomNavigationBarItem> items = new List<BottomNavigationBarItem>();
    items.add(BottomNavigationBarItem(
      icon: Icon(Icons.public),
      title: Text('Public'),
    ));
    if (["DEPARTMENT", "SOCIETY", "CHANNEL"].contains(authUser.userType)) {
      _pageOptions.add(NoticeCreateScreen());
      items.add(BottomNavigationBarItem(
        icon: Icon(Icons.add_circle_outline),
        title: Text('Add Notice'),
      ));
    }
    if (["STUDENT"].contains(authUser.userType)) {
      _pageOptions.add(PrivateNotice());
      items.add(BottomNavigationBarItem(
        icon: Icon(Icons.subject),
        title: Text('My Notice'),
      ));
    }
    if (["FACULTY"].contains(authUser.userType)) {
      _pageOptions.add(PrivateNotice());
      items.add(BottomNavigationBarItem(
        icon: Icon(Icons.vpn_key),
        title: Text('Private'),
      ));
    }
    if (["DEPARTMENT", "SOCIETY", "CHANNEL"].contains(authUser.userType)) {
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
