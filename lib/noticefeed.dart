import 'package:flutter/material.dart';
import 'package:sliet_broadcast/components/models/cardModel.dart';
import 'package:sliet_broadcast/components/noticeCard.dart';
import 'dart:async';

import 'package:sliet_broadcast/style/theme.dart' as Theme;
import 'package:sliet_broadcast/utils/network_utils.dart';

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

  List<CardModelData> cardsList = [];

  Future<Null> refreshList(_context) async {
    _getNotices().then((newData) {
      setState(() {
        cardsList.clear();
        cardsList = newData;
      });
    }).catchError((onError) {});
    return null;
  }

  Future<List<CardModelData>> _getNotices() async {
    cardsList.clear();
    var jsonData = await NetworkUtils.get(noticeUrl);

    for (var i in jsonData) {
      CardModelData card = CardModelData(
          i['id'],
          i['user'],
          i['profile'],
          i['title'],
          i['created_at'],
          i['images'],
          i['is_event'],
          i['venue'],
          i['time'],
          i['date'],
          i['description'],
          i['public_notice'],
          i['department'],
          i['images_list']);

      cardsList.add(card);
    }

    return cardsList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 80,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        // Where the linear gradient begins and ends
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Theme.Colors.loginGradientEnd,
          Theme.Colors.loginGradientStart,
        ],
      )),
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          await refreshList(context);
        },
        child: SafeArea(
          child: Center(child: list()),
        ),
      ),
    );
  }

  Widget list() {
    return FutureBuilder(
      future: _getNotices(), // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        /* switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    print('connectionstate.none was executed');
                    return Text('Press button to start.');
                  case ConnectionState.active:print('connection was active');
                                            break;
                  case ConnectionState.waiting:
                    print('we were waiting');
                    return CircularProgressIndicator();
                  case ConnectionState.done:
                    if (snapshot.hasError)
                      return Text('Error: ${snapshot.error}');
                    print('i was here');
                    return Text('Result: ${snapshot.data}');
                }
                return null; // unreachable*/
        if (snapshot.data == null) {
          return ListView(
            children: <Widget>[
              Align(
                heightFactor: 14.0,
                child: CircularProgressIndicator(),
              )
            ],
          );
        } else {
          if (snapshot.data.length < 1) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 100.0,
                  height: 100.0,
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
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return NoticeCard(
                snapshot.data[snapshot.data.length - index - 1],
              );
            },
          );
        }
      },
    );
  }
}
