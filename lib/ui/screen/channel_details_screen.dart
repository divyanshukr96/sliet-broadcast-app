import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliet_broadcast/core/constant.dart';
import 'package:sliet_broadcast/ui/widgets/notice_card.dart';
import 'package:sliet_broadcast/core/viewmodels/views/channel_model.dart';
import 'package:sliet_broadcast/ui/widgets/notice_feed.dart';
import 'package:sliet_broadcast/views/base_widget.dart';

class ChannelDetailScreen extends StatelessWidget {
  final String channelId;

  ChannelDetailScreen(this.channelId);

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      model: ChannelModel(
        channelService: Provider.of(context),
        noticeService: Provider.of(context),
      ),
      onModelReady: (ChannelModel model) {
        model.getChannelDetails(channelId);
      },
      builder: (context, ChannelModel model, _) {
        if (model.channelDetails == null) {
          return Scaffold(
            appBar: AppBar(title: Text('Channel Loading ...')),
            body: SafeArea(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(gradient: LoginLinearGradient()),
                child: NoticeNotFound(loading: model.busy),
              ),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(title: Text(model.channelDetails.name)),
          body: SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(gradient: LoginLinearGradient()),
              child: Builder(
                builder: (context) {
                  if (model.channelNotices.length == 0) {
                    return NoticeNotFound(loading: model.busy);
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    itemCount: model.channelNotices.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == model.channelNotices.length) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 2.0,
                          ),
                          child: FlatButton(
                            color: Color(0xFFDCDCDC),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text('Refresh'),
                            onPressed: () => model.getChannelDetails(channelId),
                          ),
                        );
                      }
                      return NoticeCard(
                        model.channelNotices[index],
                        model,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
