import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliet_broadcast/noticefeed.dart';
import 'package:sliet_broadcast/provider/bookmarkNoticeNotifier.dart';

class Bookmark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    dynamic provider = Provider.of<BookmarkNoticeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarks'),
      ),
      body: SafeArea(
        child: NoticeFeed(
          provider: provider,
          child: Consumer<BookmarkNoticeNotifier>(
            builder: (context, notices, notFound) {
              if (notices.fetched) notices.fetchNotice();
              return notices.notices != null &&
                      notices.notices.notices.length != 0
                  ? NoticeList(notices.notices, notices, 'bookmark')
                  : notFound;
            },
            child: Center(
              child: NoticeNotFound(
                loading: provider.loading,
                provider: provider,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
