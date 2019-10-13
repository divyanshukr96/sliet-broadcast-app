import 'package:flutter/material.dart';
import 'package:sliet_broadcast/components/models/noticeList.dart';
import 'package:sliet_broadcast/components/noticeCard.dart';
import 'package:sliet_broadcast/style/theme.dart' as Theme;

class NoticeFeed extends StatefulWidget {
  final dynamic private;
  final Widget child;
  final dynamic provider;

  NoticeFeed({this.private, @required this.child, @required this.provider});

  @override
  _NoticeFeedState createState() => _NoticeFeedState();
}

class _NoticeFeedState extends State<NoticeFeed>
    with SingleTickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  Future<Null> refreshList(_context) async {
    widget.provider.refreshNotice();
    return null;
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
          child: widget.child,
        ),
      ),
    );
  }
}

class NoticeList extends StatelessWidget {
  NoticeList(this.notices, this.provider, this._key);

  final ScrollController _scrollController = new ScrollController();

  final Notices notices;
  final provider;
  final _key;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ListView.builder(
          key: new PageStorageKey(_key),
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          itemCount: notices.notices.length + 1,
          itemBuilder: (BuildContext context, int index) {
            return (index == notices.notices.length)
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
        ),
        provider.newNotice.length >= 1
            ? Align(
                alignment: Alignment.topCenter,
                child: RaisedButton(
                  elevation: 8.0,
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  child: Text(
                    "New Notice available",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    await provider.fetchNewNotice();
                    if (provider.scrollTop) {
                      _scrollController.animateTo(
                        _scrollController.position.minScrollExtent,
                        duration: Duration(milliseconds: 1000),
                        curve: Curves.easeIn,
                      );
                      provider.scrolledToTop();
                    }
                  },
                ),
              )
            : SizedBox(height: 0.0),
      ],
    );
  }
}

class NoticeNotFound extends StatelessWidget {
  const NoticeNotFound({
    Key key,
    bool loading = false,
  })  : _loading = loading,
        super(key: key);
  final bool _loading;

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
        _loading
            ? Column(
                children: <Widget>[
                  SizedBox(height: 24.0),
                  CircularProgressIndicator(
                    backgroundColor: Colors.white54,
                  ),
                ],
              )
            : SizedBox(height: 24.0),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            _loading ? "Loading ..." : "No data available!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
