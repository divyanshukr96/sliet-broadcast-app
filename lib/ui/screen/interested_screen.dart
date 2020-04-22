import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliet_broadcast/core/viewmodels/views/interested_model.dart';
import 'package:sliet_broadcast/ui/widgets/notice_feed.dart';

class InterestedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interested events'),
      ),
      body: SafeArea(
        child: NoticeFeedPage(
          provider: InterestedModel(
            noticeService: Provider.of(context),
          ),
        ),
      ),
    );
  }
}
