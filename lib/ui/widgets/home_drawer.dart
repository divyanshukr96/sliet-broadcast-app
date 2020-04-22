import 'package:cache_image/cache_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliet_broadcast/core/constant.dart';
import 'package:sliet_broadcast/core/models/user.dart';
import 'package:sliet_broadcast/core/services/authenticationService.dart';
import 'package:sliet_broadcast/core/viewmodels/views/channel_model.dart';
import 'package:sliet_broadcast/ui/routes.dart';
import 'package:sliet_broadcast/views/base_widget.dart';

class HomeDrawer extends StatelessWidget {
  final User user;

  HomeDrawer(this.user);

  @override
  Widget build(BuildContext context) {
    ImageProvider profileUrl = AssetImage('assets/images/login.png');
    if (user.profile != null) profileUrl = CacheImage(user.profile);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              user.name ?? "Guest User",
              style: TextStyle(fontSize: 18.0),
            ),
            accountEmail: UserName(username: user.username),
            currentAccountPicture: GestureDetector(
              onTap: () {
                if (user.username != null) {
                  Navigator.popAndPushNamed(context, RoutePath.Profile);
                }
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
          ChannelsButton(),
          FollowingButton(authenticated: user.username != null),
          LoginLogout(
            authenticated: user.username != null,
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
              Navigator.pushNamed(context, RoutePath.TermsConditions);
            },
          ),
        ],
      ),
    );
  }
}

class ChannelsButton extends StatelessWidget {
  const ChannelsButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      model: ChannelModel(channelService: Provider.of(context)),
      builder: (context, ChannelModel model, _) {
        return ExpansionTile(
          onExpansionChanged: (value) async {
            if (value) await model.getAllChannel();
          },
          title: Text('Channels'),
          children: <Widget>[
            ListTile(
              title: Text('Administration'),
              leading: SizedBox(width: 0),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  RoutePath.Channel,
                  arguments: ChannelType.Administration,
                );
              },
            ),
            ListTile(
              title: Text('Department'),
              leading: SizedBox(width: 0),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  RoutePath.Channel,
                  arguments: ChannelType.Department,
                );
              },
            ),
            ListTile(
              title: Text('Society'),
              leading: SizedBox(width: 0),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  RoutePath.Channel,
                  arguments: ChannelType.Society,
                );
              },
            ),
            ListTile(
              title: Text('Other'),
              leading: SizedBox(width: 0),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  RoutePath.Channel,
                  arguments: ChannelType.Other,
                );
              },
            ),
          ],
        );
      },
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
              Navigator.pushNamed(
                context,
                RoutePath.Channel,
                arguments: ChannelType.Following,
              );
            },
          ),
          ListTile(
            title: Text('Bookmarks'),
            leading: Icon(Icons.bookmark),
            onTap: () {
              Navigator.pushNamed(context, RoutePath.Bookmarks);
            },
          ),
          ListTile(
            title: Text('Interested events'),
            leading: Icon(Icons.pan_tool),
            onTap: () {
              Navigator.pushNamed(context, RoutePath.Interested);
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
        Navigator.popAndPushNamed(context, RoutePath.Profile);
      },
      child: Text("@" + username),
    );
  }
}

class LoginLogout extends StatelessWidget {
  const LoginLogout({
    Key key,
    @required this.authenticated,
  }) : super(key: key);

  final bool authenticated;

  @override
  Widget build(BuildContext context) {
    AuthenticationService auth = Provider.of<AuthenticationService>(context);
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
              Navigator.popAndPushNamed(context, RoutePath.Profile);
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
            onTap: () async {
              //TODO LOGOUT SETUP
              auth.logout();
              Navigator.pushNamedAndRemoveUntil(
                  context, "/start", (r) => false);
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
            Navigator.popAndPushNamed(context, RoutePath.Register);
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
            Navigator.popAndPushNamed(context, RoutePath.Login);
          },
        ),
      ],
    );
  }
}
