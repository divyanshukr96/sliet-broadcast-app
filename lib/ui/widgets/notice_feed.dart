import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sliet_broadcast/core/models/notice_list.dart';
import 'package:sliet_broadcast/core/constant.dart';
import 'package:sliet_broadcast/ui/widgets/notice_card.dart';
import 'package:sliet_broadcast/core/viewmodels/notice_base_model.dart';
import 'package:sliet_broadcast/views/base_widget.dart';

class NoticeFeedPage extends StatelessWidget {
  final NoticeBaseModel provider;

  NoticeFeedPage({@required this.provider});

//  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
//      new GlobalKey<RefreshIndicatorState>();

  Future<Null> refreshList() async {
    Completer<Null> completer = Completer<Null>();
    await provider.refreshNotice(); // TODO Refresh function call here
    completer.complete();
    return await completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      model: provider,
      onModelReady: (NoticeBaseModel model) => model.getNotice(),
      builder: (context, NoticeBaseModel model, child) {
        return Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(gradient: LoginLinearGradient()),
          child: Builder(
            builder: (context) {
              if (!model.hasNotice)
                return NoticeNotFound(
                  loading: model.busy,
                  timeAgo: model.lastFetched,
                  provider: model,
                );
              return RefreshIndicator(
                onRefresh: refreshList,
                child: NoticeListView(model.notices, model, model.toString()),
              );
            },
          ),
        );
      },
    );
  }
}

//class NoticeFeedPage extends StatefulWidget {
//  final dynamic private;
//  final Widget child;
//  final dynamic provider;
//
//  NoticeFeedPage({this.private, @required this.child, @required this.provider});
//
//  @override
//  _NoticeFeedState createState() => _NoticeFeedState();
//}
//
//class _NoticeFeedState extends State<NoticeFeedPage>
//    with SingleTickerProviderStateMixin {
//  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
//      new GlobalKey<RefreshIndicatorState>();
//
//  Future<Null> refreshList() async {
//    Completer<Null> completer = Completer<Null>();
//    await widget.provider.refreshNotice();
//    completer.complete();
//    return await completer.future;
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      width: MediaQuery.of(context).size.width,
//      decoration: BoxDecoration(gradient: LoginLinearGradient()),
//      child: RefreshIndicator(
//        key: _refreshIndicatorKey,
//        onRefresh: refreshList,
//        child: SafeArea(
//          child: widget.child,
//        ),
//      ),
//    );
//  }
//}

class NoticeListView extends StatelessWidget {
  final List<Notice> notices;
  final NoticeBaseModel provider;
  final _key;

  NoticeListView(this.notices, this.provider, this._key);

  final ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ListView.builder(
          key: PageStorageKey(_key),
          controller: _scrollController,
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
          itemCount: notices.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == notices.length) {
              return LoadMoreNotice(provider: provider);
            }
//            if (index == 0) {
//              return Column(
//                children: <Widget>[
//                  buildTimeAgo(),
//                  NoticeCard(notices[index], provider),
//                ],
//              );
//            }
            return NoticeCard(notices[index], provider);
          },
        ),
        NewNoticeNotification(
          provider: provider,
          scrollController: _scrollController,
        )
      ],
    );
  }

  Widget buildTimeAgo() {
    if (provider.lastFetched == null) return SizedBox(height: 0);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        "Recently fetched ${provider.lastFetched}",
        style: TextStyle(color: Colors.white, fontSize: 12.0),
      ),
    );
  }
}

class LoadMoreNotice extends StatelessWidget {
  const LoadMoreNotice({
    Key key,
    @required this.provider,
  }) : super(key: key);

  final NoticeBaseModel provider;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 2.0,
      ),
      child: FlatButton(
        color: Color(0xFFDCDCDC),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Text(
          provider.busy ? ' Loading ... ' : "Load More",
          style: TextStyle(color: Colors.black54),
        ),
        onPressed: () {
          if (!provider.busy) provider.loadMoreNotice();
        },
      ),
    );
  }
}

class NewNoticeNotification extends StatelessWidget {
  const NewNoticeNotification({
    Key key,
    @required this.provider,
    @required ScrollController scrollController,
  })  : _scrollController = scrollController,
        super(key: key);

  final NoticeBaseModel provider; // todo Check this one
  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    if (!provider.hasNewNotice) {
      return SizedBox(height: 0);
    }
    return Align(
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
          await provider.loadNewNotice();
          _scrollController.animateTo(
            _scrollController.position.minScrollExtent,
            duration: Duration(milliseconds: 1000),
            curve: Curves.easeIn,
          );
        },
      ),
    );
  }
}

class NoticeNotFound extends StatelessWidget {
  const NoticeNotFound({
    Key key,
    bool loading = false,
    dynamic provider,
    String timeAgo,
  })  : _loading = loading,
        _provider = provider,
        _timeAgo = timeAgo,
        super(key: key);

  final bool _loading;
  final dynamic _provider;
  final String _timeAgo;

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
        buildRefreshButton(),
        buildTimeAgo()
      ],
    );
  }

  Widget buildTimeAgo() {
    if (_timeAgo == null) return SizedBox(width: 0);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "Recently fetched $_timeAgo",
        style: TextStyle(color: Colors.white70),
      ),
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
          onPressed: () async {
            await _provider.refreshNotice();
          },
          child: Icon(Icons.refresh),
        ),
      ),
    );
  }
}
