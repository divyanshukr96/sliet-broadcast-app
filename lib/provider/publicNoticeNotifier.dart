import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:sliet_broadcast/components/models/notice.dart';
import 'package:sliet_broadcast/components/models/noticeList.dart';
import 'package:sliet_broadcast/utils/network_utils.dart';

class PublicNoticeNotifier with ChangeNotifier {
  bool _fetched = true;

  bool _private = false;

  bool _authenticated = true;

  String _noticePath;

  Notices _publicNotices;

  Notices get publicNotices => _publicNotices;

  bool get fetched => _fetched;

  PublicNoticeNotifier() {
    print('dfdsfsfs');
  }

  void _lastNoticeFetched(dynamic data) {
    if (data['results'].length != 0)
      _publicNotices.lastNotice = data['results'].last['datetime'];
  }

  set notice(Notices notices) {
    _publicNotices = notices;
    notifyListeners();
  }

  set noticePath(String notices) {
    _noticePath = notices;
  }

  void fetchPublicNotice() async {
    try {
      dynamic _resData = await _loadNotices();
      if (_authenticated) {
        Notices notice = Notices.fromMap(_resData);
        _publicNotices = notice;
        _lastNoticeFetched(_resData);
      }
    } catch (e) {
      print('Error $e');
    }
    _fetched = false;
    notifyListeners();
  }

  void loadMore() async {
    try {
      dynamic _resData = await _loadNotices(_publicNotices.lastNotice);
      if (_authenticated) {
        List<Notice> data = List<Notice>.from(
          _resData['results'].map((notice) => Notice.fromMap(notice)),
        );
        if (_publicNotices != null) {
          _publicNotices.notices.addAll(data);
          _lastNoticeFetched(_resData);
        }
      }
      notifyListeners();
    } catch (e) {
      print('Error $e');
    }
  }

  Future _loadNotices([String after, String before]) async {
    _authenticated = true;
    String url = _noticePath != null
        ? _noticePath
        : _private ? "/private/notice" : "/public/notice";
    if (after != null) url += "?after=$after";
    if (before != null) url += "?before=$before";
    try {
      final Response response = await NetworkUtils.fetchData(url);
      if (response.statusCode == 401) _authenticated = false;
      if (response.statusCode != 200) {
        throw HttpException(
          'Invalid response ${response.statusCode}',
          uri: Uri.parse(url),
        );
      }
      return response.data;
    } catch (e) {
      print('Error $e');
      throw Error();
    }
  }
}
