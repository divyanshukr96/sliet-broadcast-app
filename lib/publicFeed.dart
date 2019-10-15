import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliet_broadcast/noticefeed.dart';
import 'package:sliet_broadcast/provider/publicNoticeNotifier.dart';

class PublicFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    dynamic provider = Provider.of<PublicNoticeNotifier>(context);
    return NoticeFeed(
      provider: Provider.of<PublicNoticeNotifier>(context),
      child: Consumer<PublicNoticeNotifier>(
        builder: (context, notices, notFound) {
          notices.noticePath = '/v1/public/notice';
          if (notices.fetched) notices.fetchNotice();
          return notices.notices != null
              ? NoticeList(notices.notices, notices, 'public1212')
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
