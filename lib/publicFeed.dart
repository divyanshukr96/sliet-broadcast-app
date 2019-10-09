import 'package:flutter/material.dart';
import 'package:sliet_broadcast/noticefeed.dart';

class PublicFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NoticeFeed('/v1/public/notice');
  }
}
