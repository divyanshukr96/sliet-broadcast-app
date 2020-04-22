import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sliet_broadcast/ui/screen/channel_list_screen.dart';
import 'package:sliet_broadcast/ui/screen/profile_screen.dart';
import 'package:sliet_broadcast/ui/screen/terms_conditions_screen.dart';
import 'package:sliet_broadcast/ui/screen/interested_screen.dart';
import 'package:sliet_broadcast/ui/screen/register_screen.dart';
import 'package:sliet_broadcast/ui/screen/bookmark_screen.dart';
import 'package:sliet_broadcast/ui/screen/channel_details_screen.dart';
import 'package:sliet_broadcast/ui/screen/login_screen.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePath.Channel:
        return MaterialPageRoute(
          builder: (_) => ChannelList(settings.arguments),
        );
      case RoutePath.ChannelDetails:
        return MaterialPageRoute<bool>(
          builder: (_) => ChannelDetailScreen(settings.arguments),
        );

      case RoutePath.Register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case RoutePath.Login:
        return MaterialPageRoute(builder: (_) => LoginScreen());

      case RoutePath.Profile:
        return MaterialPageRoute(builder: (_) => ProfileScreen());

      case RoutePath.Bookmarks:
        return MaterialPageRoute(builder: (_) => BookmarkScreen());
      case RoutePath.Interested:
        return MaterialPageRoute(builder: (_) => InterestedScreen());

      case RoutePath.TermsConditions:
        return MaterialPageRoute(builder: (_) => TermsConditionsScreen());

//      case RoutePath.Post:
//        var post = settings.arguments as Post;
//        return MaterialPageRoute(builder: (_) => PostView(post: post));

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}

class RoutePath {
  static const String Register = 'register';
  static const String Login = 'login';

//  static const String Home = '/';
//  static const String Post = 'post';

  static const String Profile = 'profile';

  static const String Channel = 'Channel';
  static const String ChannelDetails = 'channel_details';

  static const String Bookmarks = "bookmarks";
  static const String Interested = "interested";

  static const String TermsConditions = "TermsConditions";
}
