import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
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
      print(newData);
      setState(() {
        cardsList.clear();
        cardsList = newData;
      });
    }).catchError((onError) {
      print(
          '----------------------------------------------------------------****************************************************************************************************');
      print(onError.toString());
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
          i['created_at'].split(" ")[0],
          i['created_at'].split(" ")[1],
          i['images'],
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
                heightFactor: 15.0,
                child: CircularProgressIndicator(),
              )
            ],
          );
        } else {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
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
