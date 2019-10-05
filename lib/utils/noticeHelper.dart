import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:sliet_broadcast/components/models/notice.dart';
import 'package:sliet_broadcast/components/models/noticeList.dart';

class NoticeNotifier with ChangeNotifier {
  bool _fetched = true;
  Notices _publicNotices;

  Notices get publicNotices => _publicNotices;

  bool get fetched => _fetched;

  void _lastNoticeFetched(dynamic data) {
    if (data['results'].length != 0)
      _publicNotices.lastNotice = data['results'].last['datetime'];
  }

  set notice(Notices notices) {
    _publicNotices = notices;
    notifyListeners();
  }

  void fetchPublicNotice() async {
    dynamic _resData = await _loadNotices();
    Notices notice = Notices.fromMap(_resData);
    _publicNotices = notice;
    _lastNoticeFetched(_resData);
    _fetched = false;
    notifyListeners();
  }

  void loadMore() async {
//    _publicNotices = await _loadNotices(_publicNotices.nextPage);
    dynamic _resData = await _loadNotices(_publicNotices.lastNotice);

//    if (publicNotices.totalNotices != _resData['count']) {
//      print(_resData['count'] - publicNotices.totalNotices);
//      dynamic d = _resData['results']
//          .removeRange(0, _resData['count'] - publicNotices.totalNotices);
//      print(_resData['results'].length);
//      print(d);
//    }

    List<Notice> data = List<Notice>.from(
      _resData['results'].map((notice) => Notice.fromMap(notice)),
    );

    if (_publicNotices != null) {
      _publicNotices.notices.addAll(data);
      _lastNoticeFetched(_resData);
    }

    notifyListeners();
  }

  int temp = 1;

  dynamic _data = [];

//  Future<Notices> _loadNotices([int page]) async {
//    String url = "/public/notice";
//    print(page);
//    if (page == null) url += "?page=$temp";
//    temp++;
//    final Response response = await _fetchData(url);
//    dynamic data = List<Notice>.from(
//      response.data['results'].map((notice) => Notice.fromMap(notice)),
//    );
//
//    _data.addAll(data);
//    print(_data);
//
//    if (_publicNotices != null) _publicNotices.notices.addAll(data);
//
////    _publicNotices = [..._publicNotices.notices, ];
//    return new Notices();
//  }
}

Future _loadNotices([String after, String before]) async {
  String url = "/public/notice";
  if (after != null) url += "?after=$after";
  if (before != null) url += "?before=$before";
  final Response response = await _fetchData(url);
  return response.data;
}

//Future<List<Notices>> _loadLocations(
//    String query,
//    bool fromCache,
//    SearchType locationType,
//    ) =>
//    fromCache
//        ? (locationType == SearchType.origin
//        ? cache.locationOrigin
//        : cache.locationDestination)
//        : a
//        pi.locations(query);

Future _fetchData(String url) async {
  Dio dio = new Dio();
  Response response = await dio.get('http://192.168.137.1:8000/api$url');

  if (response.statusCode != 200) {
    print('Error ${response.statusCode}: $url');
    throw HttpException(
      'Invalid response ${response.statusCode}',
      uri: Uri.parse(url),
    );
  }

  return response;
}
