import 'package:flutter/material.dart';
import 'package:sliet_broadcast/style/theme.dart' as Theme;

enum NoticeType { Public, Private, Published, Bookmark, Interested }

enum ChannelType { Administration, Department, Society, Other, Following }

//class ChannelType {
//  static const Administration = "Administration";
//  static const Department = "Department";
//  static const Society = "Society";
//  static const Other = "Other";
//}

_channelTypeToString(ChannelType channelType) {
  switch (channelType) {
    case ChannelType.Administration:
      return "Administration";
    case ChannelType.Department:
      return "Department";
    case ChannelType.Society:
      return "Society";
    case ChannelType.Other:
      return "Other";
    case ChannelType.Following:
      return "Following";
      break;
  }
  return "Channel";
}

class ChannelTypeValue {
  static get(ChannelType channelType) {
    return _channelTypeToString(channelType);
  }
}

class LoginLinearGradient extends LinearGradient {
  LoginLinearGradient()
      : super(
          colors: [
            Theme.Colors.loginGradientStart,
            Theme.Colors.loginGradientEnd,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          tileMode: TileMode.clamp,
        );
}

Pattern emailPattern =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
