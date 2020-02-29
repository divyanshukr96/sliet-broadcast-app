import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliet_broadcast/noticefeed.dart';
import 'package:sliet_broadcast/provider/privateNoticeNotifier.dart';

class PrivateFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    dynamic provider = Provider.of<PrivateNoticeNotifier>(context);
    return NoticeFeed(
      provider: provider,
      child: Consumer<PrivateNoticeNotifier>(
        builder: (context, notices, notFound) {
          if (notices.fetched) notices.fetchNotice();
          return notices.notices != null && notices.notices.notices.length != 0
              ? NoticeList(notices.notices, notices, 'private002')
              : notFound;
        },
        child: Center(
          child: NoticeNotFound(
            loading: provider.loading,
            provider: provider,
          ),
        ),
      ),
    );
  }
}
