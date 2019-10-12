import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliet_broadcast/components/channelList.dart';
import 'package:sliet_broadcast/components/register.dart';
import 'package:sliet_broadcast/components/terms_conditions.dart';
import 'package:sliet_broadcast/login.dart';
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
          UserAccountsDrawerHeader(
            accountName: Text(
              profile['name'] ?? "Guest User",
              style: TextStyle(fontSize: 18.0),
            ),
            accountEmail: UserName(username: profile['username']),
            currentAccountPicture: GestureDetector(
              onTap: () {
                if (authenticated)
                  Navigator.popAndPushNamed(context, '/profile');
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: profileUrl,
                  ),
                ),
              ),
            ),
          ),
          ExpansionTile(
            title: Text('Channels'),
            children: <Widget>[
              ListTile(
                title: Text('Administration'),
                leading: SizedBox(width: 0),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => ChannelList(
                          'Administration', '/api/channel?admin=true'),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Department'),
                leading: SizedBox(width: 0),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => ChannelList(
                          'Department', '/api/channel?type=DEPARTMENT'),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Society'),
                leading: SizedBox(width: 0),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ChannelList('Society', '/api/channel?type=SOCIETY'),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Other'),
                leading: SizedBox(width: 0),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => ChannelList(
                          'Broadcast Channel', '/api/channel?type=CHANNEL'),
                    ),
                  );
                },
              ),
            ],
          ),
          FollowingButton(authenticated: authenticated),
//          ListTile(
//            title: Text('Bookmarks'),
//            leading: Icon(Icons.bookmark),
//            onTap: () {},
//          ),
          LoginLogout(
            sharedPreferences: _sharedPreferences,
            authenticated: authenticated,
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('Terms & Conditions'),
              ],
            ),
            leading: Icon(Icons.library_books),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => TermsAndConditions(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class FollowingButton extends StatelessWidget {
  const FollowingButton({
    Key key,
    @required this.authenticated,
  }) : super(key: key);

  final bool authenticated;

  @override
  Widget build(BuildContext context) {
    if (authenticated)
      return Column(
        children: <Widget>[
          ListTile(
            title: Text('Following'),
            leading: Icon(Icons.people),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      ChannelList('Following', '/api/channel/following'),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Bookmarks'),
            leading: Icon(Icons.bookmark),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      ChannelList('Following', '/api/channel/following'),
                ),
              );
            },
          ),
        ],
      );
    return SizedBox(height: 0.0);
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
      child: Text("@" + username),
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
    return Column(
      children: <Widget>[
        Divider(),
        ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Register',
                style: TextStyle(),
              ),
            ],
          ),
          leading: Icon(Icons.create),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => Register(),
              ),
            );
          },
        ),
        ListTile(
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
        ),
      ],
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
