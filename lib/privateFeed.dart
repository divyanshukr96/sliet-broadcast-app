import 'package:flutter/material.dart';
import 'package:sliet_broadcast/noticefeed.dart';

class PrivateFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NoticeFeed('/api/private/notice');
  }
}
