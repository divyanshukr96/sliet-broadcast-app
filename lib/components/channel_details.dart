import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sliet_broadcast/components/models/notice.dart';
import 'package:sliet_broadcast/components/noticeCard.dart';
import 'package:sliet_broadcast/noticefeed.dart';
import 'package:sliet_broadcast/utils/network_utils.dart';
import 'package:sliet_broadcast/style/theme.dart' as Themes;

class ChannelDetail extends StatefulWidget {
  final String channelId;

  ChannelDetail(this.channelId);

  @override
  _ChannelDetailState createState() => _ChannelDetailState();
}

class _ChannelDetailState extends State<ChannelDetail> {
  Dio _dio = new Dio();

  bool loading = true;

  Map<String, dynamic> data = Map<String, dynamic>()
    ..addAll({'name': 'Channel Loading ...'});

  List<Notice> _notices = List<Notice>();

  @override
  void initState() {
    _getChannelDetail();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data['name']),
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Themes.Colors.loginGradientEnd,
                Themes.Colors.loginGradientStart,
              ],
            ),
          ),
          child: _notices == null || _notices.length == 0
              ? NoticeNotFound(loading: loading)
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  itemCount: _notices == null ? 0 : _notices.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    return (index == _notices.length)
                        ? Container(
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
                              onPressed: _getChannelDetail,
                            ),
                          )
                        : NoticeCard(_notices[index]);
                  },
                ),
        ),
      ),
    );
  }

  void _getChannelDetail() async {
    try {
      Response response = await _dio.get(
        NetworkUtils.host + '/api/user/${widget.channelId}',
      );
      if (response.statusCode == 200) {
        setState(() {
          _notices = List<Notice>.from(
            response.data['notices'].map((notice) => Notice.fromMap(notice)),
          );
          data = response.data;
        });
      }
    } catch (error) {
      print('Error channel_detail _getChannelDetails $error');
    }
    loading = false;
  }
}
