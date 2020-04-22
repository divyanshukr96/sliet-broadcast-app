import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliet_broadcast/core/viewmodels/views/public_notice_model.dart';
import 'package:sliet_broadcast/ui/widgets/notice_feed.dart';

class PublicNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NoticeFeedPage(
      provider: PublicNoticeModel(
        noticeService: Provider.of(context),
      ),
    );
  }
}
