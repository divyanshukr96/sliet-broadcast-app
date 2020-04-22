import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliet_broadcast/core/viewmodels/views/bookmark_model.dart';
import 'package:sliet_broadcast/ui/widgets/notice_feed.dart';

class BookmarkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarks'),
      ),
      body: SafeArea(
        child: NoticeFeedPage(
          provider: BookmarkModel(
            noticeService: Provider.of(context),
          ),
        ),
      ),
    );
  }
}
