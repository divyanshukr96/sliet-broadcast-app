import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliet_broadcast/login.dart';
import 'package:sliet_broadcast/style/theme.dart' as Theme;
import 'package:sliet_broadcast/utils/network_utils.dart';

class HomeDrawer extends StatefulWidget {
  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  NetworkUtils networkUtils = new NetworkUtils();

  Map<String, dynamic> profile = new Map<String, dynamic>();

  bool authenticated = false;

  @override
  void initState() {
    _getUserProfile();
    networkUtils.isAuthenticated().then((onValue) {
      setState(() {
        authenticated = onValue;
      });
    });
    super.initState();
    _fetchSessionAndNavigate();
  }

  void _getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('profile') ?? 0;
    if (value == 0 || value == 'null') {
      final value = jsonEncode(await NetworkUtils.get('/api/auth/user'));
      prefs.setString('profile', value);
    }
    if (value != 0 && value != 'null') {
      setState(() {
        profile = jsonDecode(value);
      });
    }
  }

  _fetchSessionAndNavigate() async {
    _sharedPreferences = await _prefs;
//    authenticated = AuthUtils.isAuthenticated(_sharedPreferences);
//    if (authenticated) {
//      print('is authentication');
//    } else {
//      print(
//          '------------------------------- not authentication -----------------------');
//    }
    if (authenticated != null) {
//      Navigator.of(_scaffoldKey.currentContext).push(
//        MaterialPageRoute(
//          builder: (BuildContext context) => PublicFeed(),
//        ),
//      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider profileUrl = AssetImage('assets/images/login.png');
    if (profile['profile'] != null) {
      profileUrl = NetworkImage(profile['profile']);
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text(
                    'SLIET BROADCAST',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
                Spacer(),
                Row(
                  children: <Widget>[
                    Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: profileUrl,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 16.0, bottom: 8.0),
                            child: Text(
                              profile['name'] ?? "Guest User",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                          UserName(username: profile['username']),
                        ],
                      ),
                    )
                  ],
                ),
                Spacer(),
              ],
            ),
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Theme.Colors.loginGradientEnd,
                Theme.Colors.loginGradientStart,
              ],
            )),
          ),
          LoginLogout(
            sharedPreferences: _sharedPreferences,
            authenticated: authenticated,
          ),
//          DrawerItem('Terms & Conditions', Icon(Icons.library_books), context,
//                  testFunction)
//              .getItem(),
        ],
      ),
    );
  }

  void testFunction() {
    print('hello ');
  }
}

class UserName extends StatelessWidget {
  const UserName({
    Key key,
    @required this.username,
  }) : super(key: key);

  final String username;

  @override
  Widget build(BuildContext context) {
    if (username == null)
      return SizedBox(
        height: 0.0,
      );
    return GestureDetector(
      onTap: () {
        Navigator.popAndPushNamed(context, '/profile');
      },
      child: Padding(
        padding: EdgeInsets.only(left: 16.0, top: 4.0),
        child: Text(
          "@" + username,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class LoginLogout extends StatelessWidget {
  const LoginLogout({
    Key key,
    @required SharedPreferences sharedPreferences,
    @required this.authenticated,
  })  : _sharedPreferences = sharedPreferences,
        super(key: key);

  final SharedPreferences _sharedPreferences;
  final bool authenticated;

  @override
  Widget build(BuildContext context) {
    if (authenticated) {
      return Column(
        children: <Widget>[
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('Profile'),
              ],
            ),
            leading: Icon(Icons.account_circle),
            onTap: () {
              Navigator.popAndPushNamed(context, '/profile');
            },
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('Logout'),
              ],
            ),
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              NetworkUtils.logoutUser(context, _sharedPreferences);
            },
          ),
        ],
      );
    }
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            'Login',
            style: TextStyle(),
          ),
        ],
      ),
      leading: Icon(Icons.person_outline),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => LoginPage(),
          ),
        );
      },
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            'Login',
            style: TextStyle(),
          ),
        ],
      ),
      leading: Icon(Icons.person_outline),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => LoginPage(),
          ),
        );
      },
    );
  }
}
