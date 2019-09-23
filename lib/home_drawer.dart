import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliet_broadcast/components/drawerItem.dart';
import 'package:sliet_broadcast/login.dart';
import 'package:sliet_broadcast/style/theme.dart' as Theme;
import 'package:sliet_broadcast/utils/auth_utils.dart';
import 'package:sliet_broadcast/utils/network_utils.dart';

class HomeDrawer extends StatefulWidget {
  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  NetworkUtils networkUtils = new NetworkUtils();

  bool authenticated = false;

  @override
  void initState() {
    networkUtils.isAuthenticated().then((onValue) {
      print(onValue.toString()+ " on sucess home_drawer.dart initstate");
      setState(() {
        authenticated = onValue;
      });
    });

    super.initState();
    print(
        "helo------------------------------------------------------------------------");
    _fetchSessionAndNavigate();
  }

  _fetchSessionAndNavigate() async {
    _sharedPreferences = await _prefs;
//    authenticated = AuthUtils.isAuthenticated(_sharedPreferences);
    if (authenticated) {
      print('is authentication');
    } else {
      print(
          '------------------------------- not authentication -----------------------');
    }
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
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new NetworkImage(
                            "https://i.imgur.com/BoN9kdC.png",
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        'Guest User',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
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
          DrawerItem('click for hello', Icon(Icons.unfold_more), context,
                  testFunction)
              .getItem(),
        ],
      ),
    );
  }

  void testFunction() {
    print('hello ');
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
      return ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'Logout',
            ),
          ],
        ),
        leading: Icon(Icons.exit_to_app),
        onTap: () {
          NetworkUtils.logoutUser(context, _sharedPreferences);
        },
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
