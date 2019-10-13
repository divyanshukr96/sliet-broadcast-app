import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliet_broadcast/noticefeed.dart';
import 'package:sliet_broadcast/provider/bookmarkNoticeNotifier.dart';

class Bookmark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool loading = true;
    return NoticeFeed(
      provider: Provider.of<BookmarkNoticeNotifier>(context),
      child: Consumer<BookmarkNoticeNotifier>(
        builder: (context, notices, notFound) {
          notices.noticePath = '/bookmark';
          if (notices.fetched) notices.fetchNotice();
          loading = notices.loading;
          return notices.notices != null
              ? NoticeList(notices.notices, notices, 'bookmark')
              : notFound;
        },
        child: Center(child: NoticeNotFound(loading: loading)),
      ),
    );
  }
}
