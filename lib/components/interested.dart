import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliet_broadcast/noticefeed.dart';
import 'package:sliet_broadcast/provider/interestedNoticeNotifier.dart';

class Interested extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    dynamic provider = Provider.of<InterestedNoticeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Interested events'),
      ),
      body: SafeArea(
        child: NoticeFeed(
          provider: provider,
          child: Consumer<InterestedNoticeNotifier>(
            builder: (context, notices, notFound) {
              if (notices.fetched) notices.fetchNotice();
              return notices.notices != null &&
                      notices.notices.notices.length != 0
                  ? NoticeList(notices.notices, notices, 'interested')
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
