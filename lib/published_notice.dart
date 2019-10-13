import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliet_broadcast/noticefeed.dart';
import 'package:sliet_broadcast/provider/privateNoticeNotifier.dart';

class PublishedNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool loading = true;
    return NoticeFeed(
      provider: Provider.of<PrivateNoticeNotifier>(context),
      child: Consumer<PrivateNoticeNotifier>(
        builder: (context, notices, notFound) {
          notices.noticePath = '/v1/private/notice';
          if (notices.fetched) notices.fetchNotice();
          loading = notices.loading;
          return notices.notices != null
              ? NoticeList(notices.notices, notices, 'published')
              : notFound;
        },
        child: Center(child: NoticeNotFound(loading: loading)),
      ),
    );
  }
}
