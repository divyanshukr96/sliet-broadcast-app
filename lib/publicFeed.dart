import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliet_broadcast/noticefeed.dart';
import 'package:sliet_broadcast/provider/publicNoticeNotifier.dart';

class PublicFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool loading = true;
    return NoticeFeed(
      provider: Provider.of<PublicNoticeNotifier>(context),
      child: Consumer<PublicNoticeNotifier>(
        builder: (context, notices, notFound) {
          notices.noticePath = '/v1/public/notice';
          if (notices.fetched) notices.fetchNotice();
          loading = notices.loading;
          return notices.notices != null
              ? NoticeList(notices.notices, notices, 'public1212')
              : notFound;
        },
        child: Center(child: NoticeNotFound(loading: loading)),
      ),
    );
  }
}
