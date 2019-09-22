import 'package:flutter/material.dart';
import 'package:sliet_broadcast/components/drawerItem.dart';
import 'package:sliet_broadcast/login.dart';
import 'package:sliet_broadcast/style/theme.dart' as Theme;

class HomeDrawer extends StatefulWidget {
  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
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
