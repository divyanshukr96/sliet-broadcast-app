import 'package:cache_image/cache_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliet_broadcast/ui/widgets/button/custom_button.dart';
import 'package:sliet_broadcast/core/models/channel.dart';
import 'package:sliet_broadcast/core/constant.dart';
import 'package:sliet_broadcast/core/viewmodels/views/channel_model.dart';
import 'package:sliet_broadcast/ui/widgets/notice_feed.dart';
import 'package:sliet_broadcast/ui/routes.dart';
import 'package:sliet_broadcast/utils/toast.dart';
import 'package:sliet_broadcast/views/base_widget.dart';

class ChannelList extends StatelessWidget {
  final ChannelType title;

  ChannelList(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ChannelTypeValue.get(title)),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(gradient: LoginLinearGradient()),
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: BaseWidget(
          model: ChannelModel(channelService: Provider.of(context)),
          onModelReady: (ChannelModel model) async {
            if (model.allChannels == null) await model.getAllChannel();
            model.channelType = title;
          },
          builder: (context, ChannelModel model, _) {
            if (!model.hasChannel || model.channels.length == 0) {
              return NoticeNotFound(loading: model.busy);
            }
            return ListView.builder(
              itemCount: model.channels.length,
              itemBuilder: (BuildContext context, int index) {
                return ChannelCard(
                  channel: model.channels[index],
                  model: model,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class ChannelCard extends StatelessWidget {
  final Channel channel;
  final ChannelModel model;

  ChannelCard({
    this.channel,
    this.model,
  }) : super(key: Key(channel.id));

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 2.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    RoutePath.ChannelDetails,
                    arguments: channel.id,
                  );
                },
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 4.0),
                    CircleAvatar(
                      backgroundImage: channel.profile != ""
                          ? CacheImage(channel.profile)
                          : AssetImage('assets/images/login.png'),
                      radius: 28.0,
                      backgroundColor: Colors.black,
                      //change this to backgroundImage
                    ),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            channel.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 2.0),
                          Text('@${channel.username}')
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Builder(
              builder: (context) {
                if (!channel.auth || channel.isAdmin) {
                  return SizedBox(width: 0);
                }
                return CustomIconButton(
                  child: InkWell(
                    child: Icon(
                      channel.following
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: channel.following ? Colors.lightBlue : Colors.grey,
                    ),
                    onTap: () async {
                      if (channel.canUnFollow) {
                        Toast.show(
                          "You can't unfollw ${channel.name}",
                          context,
                          duration: Toast.LENGTH_LONG,
                          gravity: Toast.BOTTOM,
                        );
                        return;
                      }
                      await model.followChannel(channel.id);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
