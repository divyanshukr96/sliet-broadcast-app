import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:sliet_broadcast/components/models/notice.dart';
import 'package:sliet_broadcast/components/models/noticeList.dart';
import 'package:sliet_broadcast/utils/network_utils.dart';

class NoticeNotifier with ChangeNotifier {
  bool _fetched = true;

  bool _loading = true;

  bool _authenticated = true;

  String _noticePath;

  Notices _notices;

  List<Notice> _newNotice = List<Notice>();

  bool _scrollToTop = false;

  Notices get notices => _notices;

  List<Notice> get newNotice => _newNotice;

  bool get fetched => _fetched;

  bool get loading => _loading;

  void scrolledToTop() {
    _scrollToTop = false;
    notifyListeners();
  }

  bool get scrollTop => _scrollToTop;

  _lastNoticeFetched(dynamic data) {
    if (data['results'].length != 0)
      _notices.lastNotice = data['results'].last['datetime'];
  }

  _firstNoticeFetched(dynamic data) {
    if (data['results'].length != 0)
      _notices.firstNotice = data['results'].first['datetime'];
  }

  set notice(Notices notices) {
    _notices = notices;
    notifyListeners();
  }

  set noticePath(String notices) {
    _noticePath = notices;
  }

  void refreshNotice() async {
    _fetched = true;
    _loading = true;
    _notices = null;
    notifyListeners();
    fetchNotice();
  }

  void fetchNotice() async {
    try {
      dynamic _resData = await _loadNotices();
      if (_authenticated) {
        Notices notice = Notices.fromMap(_resData);
        _notices = notice;
        _newNotice.clear();
        await _firstNoticeFetched(_resData);
        await _lastNoticeFetched(_resData);
      }
    } catch (e) {
      print('noticeHelper fetchNotice catch Error $e');
    }
    _fetched = false;
    _loading = false;
    notifyListeners();
  }

  void loadMore() async {
    _loading = true;
    notifyListeners();
    try {
      dynamic _resData = await _loadNotices(after: _notices.lastNotice);
      if (_authenticated) {
        List<Notice> data = List<Notice>.from(
          _resData['results'].map((notice) => Notice.fromMap(notice)),
        );
        if (_notices != null) {
          _notices.notices.addAll(data);
          _lastNoticeFetched(_resData);
        }
      }
      notifyListeners();
      _loading = false;
      try {
        dynamic _newResData = await _loadNotices(before: _notices.firstNotice);
        if (_authenticated) {
          _newNotice = List<Notice>.from(
            _newResData['results'].map((notice) => Notice.fromMap(notice)),
          );
        }
      } catch (e) {
        print('noticeHelper loadMore _loadNotices onCatch Error $e');
      }
      notifyListeners();
    } catch (e) {
      print('noticeHelper loadMore onCatch Error $e');
    }
  }

  void fetchNewNotice() async {
    if (_newNotice.length == 0) return;
    _notices.notices.insertAll(0, _newNotice);
    _notices.firstNotice = _newNotice.first.dateTime;
    _newNotice.clear();
    _scrollToTop = true;
    notifyListeners();
  }

  Future _loadNotices({String after, String before}) async {
    _authenticated = true;
    String url = _noticePath;
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
      print('noticeHelper _loadNotices Error $e');
      throw Error();
    }
  }
}
