import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sliet_broadcast/style/theme.dart' as Theme;
import './components/models/cardModel.dart';
import './components/noticeCard.dart';

class PublicFeed extends StatefulWidget {
  @override
  _PublicFeedState createState() => _PublicFeedState();
}

class _PublicFeedState extends State<PublicFeed> {
  var url = "http://192.168.137.1:8000/api/public/notice";

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  List<CardModelData> cardsList = [];

  Future<Null> refreshList(_context) async {
    _getNotices().then((newData) {
      setState(() {
        cardsList.clear();
        cardsList = newData;
      });
    });
    return null;
  }

  Future<List<CardModelData>> _getNotices() async {
    var data = await http.get(url);
    print(url);
    var jsonData = json.decode(data.body);

    for (var i in jsonData) {
      CardModelData card = CardModelData(
          i['id'],
          i['user'],
          i['title'],
          i['date'],
          i['time'],
          i['https://www.w3.org/TR/2017/WD-html52-20170117/images/elo.png'],
          i['time'],
          i['date'],
          i['venue'],
          i['description']);

      cardsList.add(card);
    }

    return cardsList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
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
      child: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: () async {
            await refreshList(context);
          },
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
          return CircularProgressIndicator();
        } else {
          return ListView.builder(
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
