import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliet_broadcast/core/viewmodels/views/private_notice_model.dart';
import 'package:sliet_broadcast/ui/widgets/notice_feed.dart';

class PrivateNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NoticeFeedPage(
      provider: PrivateNoticeModel(
        noticeService: Provider.of(context),
      ),
    );
  }
}
