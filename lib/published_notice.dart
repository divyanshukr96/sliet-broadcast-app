import 'package:flutter/material.dart';
import 'package:sliet_broadcast/noticefeed.dart';

class PublishedNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NoticeFeed("/private/notice");
  }
}
