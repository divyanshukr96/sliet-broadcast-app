import 'dart:async';
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

  Future<Null> refreshList() async {
    Completer<Null> completer = Completer<Null>();
    await widget.provider.refreshNotice();
    completer.complete();
    return await completer.future;
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
        onRefresh: refreshList,
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
          key: PageStorageKey(_key),
          controller: _scrollController,
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
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
                        provider.loading ? ' Loading ... ' : "Load More",
                        style: TextStyle(color: Colors.black54),
                      ),
                      onPressed: () {
                        if (!provider.loading) provider.loadMore();
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
    dynamic provider,
  })  : _loading = loading,
        _provider = provider,
        super(key: key);
  final bool _loading;
  final dynamic _provider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 120.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/splash_screen.png'),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              _loading
                  ? Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white54,
                      ),
                    )
                  : SizedBox(height: 8.0),
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
          ),
        ),
        buildRefreshButton()
      ],
    );
  }

  Widget buildRefreshButton() {
    if (_provider == null || _provider == "") return SizedBox(height: 0.0);
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FloatingActionButton(
          tooltip: 'Refresh',
          backgroundColor: Colors.white70,
          foregroundColor: Colors.black38,
          onPressed: () {
            _provider.refreshNotice();
          },
          child: Icon(Icons.refresh),
        ),
      ),
    );
  }
}
