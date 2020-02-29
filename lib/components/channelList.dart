import 'package:cache_image/cache_image.dart';
import 'package:flutter/material.dart';
import 'package:sliet_broadcast/noticefeed.dart';
import 'package:sliet_broadcast/utils/network_utils.dart';
import 'package:sliet_broadcast/utils/toast.dart';
import 'package:sliet_broadcast/style/theme.dart' as Theme;

class ChannelList extends StatefulWidget {
  final String path;
  final String title;
  final String type;

  ChannelList(this.title, this.path, [this.type]);

  @override
  _ChannelListState createState() => _ChannelListState();
}

class _ChannelListState extends State<ChannelList> {
  List<dynamic> channelList;
  bool loading = true;

  @override
  void initState() {
    _fetchChannelList();
    super.initState();
  }

  _fetchChannelList() async {
    String _url = widget.path ?? '/api/channel';
    if (widget.type != null) _url += "?type=${widget.type}";
    try {
      var data = await NetworkUtils.get(_url);
      setState(() {
        channelList = data;
      });
    } catch (e) {
      print('channelList _fetchChannelList Error $e');
    }
    loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Channel'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.Colors.loginGradientEnd,
              Theme.Colors.loginGradientStart,
            ],
          ),
        ),
        padding: EdgeInsets.all(8.0),
        child: channelList == null || channelList.length == 0
            ? NoticeNotFound(
                loading: loading,
              )
            : ListView.builder(
                itemCount: channelList != null ? channelList.length : 0,
                itemBuilder: (BuildContext context, int index) {
                  return ChannelCard(channel: channelList[index]);
                },
              ),
      ),
    );
  }
}

class ChannelCard extends StatelessWidget {
  const ChannelCard({
    Key key,
    @required this.channel,
  }) : super(key: key);

  final dynamic channel;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: channel['profile'] != null
                  ? CacheImage(channel['profile'])
                  : AssetImage('assets/images/login.png'),
              radius: 36.0,
              backgroundColor: Colors.black, //change this to backgroundImage
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed('/details', arguments: channel['id']);
                      },
                      child: Text(
                        channel['name'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('@${channel['username']}'),
                        FollowButton(channel: channel),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FollowButton extends StatefulWidget {
  const FollowButton({
    Key key,
    @required this.channel,
  }) : super(key: key);

  final dynamic channel;

  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool _following = false;

  _followChannel() async {
    try {
      String url = '/api/channel/follow/${widget.channel['id']}';
      final response = await NetworkUtils.post(url, null);
      setState(() {
        _following = response['following'];
      });
    } catch (e) {
      print('_followChannel error in channel list : $e');
    }
  }

  @override
  void initState() {
    _following = widget.channel['following'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.channel['auth']) return SizedBox(height: 0.0);
    return Align(
      alignment: Alignment.centerRight,
      child: MaterialButton(
        minWidth: 50,
        height: 28,
        highlightColor: Colors.transparent,
        splashColor: Colors.grey,
        textColor: Colors.white,
        color: _following ? Color(0xFF5C19D9) : Colors.lightBlueAccent,
        child: _following ? Text("Following") : Text("Follow"),
        onPressed: () {
          if (widget.channel['is_admin']) {
            Toast.show(
              "You can't unfollw ${widget.channel['name']}",
              context,
              duration: Toast.LENGTH_LONG,
              gravity: Toast.BOTTOM,
            );
            return;
          }
          _followChannel();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
