import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliet_broadcast/components/models/notice.dart';
import 'package:sliet_broadcast/components/noticeCard.dart';
import 'package:sliet_broadcast/style/theme.dart' as Theme;
import 'package:sliet_broadcast/utils/network_utils.dart';
import 'package:sliet_broadcast/utils/noticeHelper.dart';
import 'components/models/noticeList.dart';

class NoticeFeed extends StatefulWidget {
  final String noticeLink;

  NoticeFeed(this.noticeLink);

  @override
  _NoticeFeedState createState() => _NoticeFeedState(noticeLink);
}

class _NoticeFeedState extends State<NoticeFeed> {
  final String noticeUrl;

  _NoticeFeedState(this.noticeUrl);

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  List<Notice> cardsList = [];

  Future<Null> refreshList(_context) async {
    _getNotices().then((newData) {
      setState(() {
        cardsList.clear();
        cardsList = newData;
      });
    }).catchError((onError) {});
    return null;
  }

  Future<List<Notice>> _getNotices() async {
    cardsList.clear();
    var jsonData = await NetworkUtils.get(noticeUrl);

    for (var notice in jsonData) {
      Notice card = Notice.fromMap(notice);
      cardsList.add(card);
    }

    return cardsList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          await refreshList(context);
        },
        child: SafeArea(
          child: Center(
            child: Consumer<NoticeNotifier>(
              builder: (context, notices, notFound) {
                if (notices.fetched) notices.fetchPublicNotice();
//                return Container(
//                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
//                  child: FlatButton(
//                    color: Color(0xFFDCDCDC),
//                    shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(8.0),
//                    ),
//                    child: Text(
//                      "Load More",
//                      style: TextStyle(color: Colors.black54),
//                    ),
//                    onPressed: () {
//                      notices.loadMore();
//                    },
//                  ),
//                );
                return notices.publicNotices != null
                    ? NoticeList(notices.publicNotices, notices)
                    : notFound;
              },
              child: NoticeNotFound(),
            ),
          ),
        ),
      ),
    );
  }
}

class NoticeList extends StatelessWidget {
  NoticeList(this.notices, this.provider);

  final Notices notices;
  final provider;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: notices.notices.length + 1,
      itemBuilder: (BuildContext context, int index) {
        return (index == notices.notices.length)
            ? Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                child: FlatButton(
                  color: Color(0xFFDCDCDC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    "Load More",
                    style: TextStyle(color: Colors.black54),
                  ),
                  onPressed: () {
                    provider.loadMore();
                  },
                ),
              )
            : NoticeCard(notices.notices[index]);
      },
    );
  }
}

class NoticeNotFound extends StatelessWidget {
  const NoticeNotFound({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 120.0,
          height: 120.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/login.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 16.0),
        Text(
          "Welcome to SLIET Broadcast App",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
