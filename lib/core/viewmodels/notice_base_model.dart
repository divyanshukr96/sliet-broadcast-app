import 'dart:async';
import 'package:sliet_broadcast/core/models/notice_list.dart';
import 'package:sliet_broadcast/core/constant.dart';
import 'package:sliet_broadcast/core/services/notice_service.dart';
import 'package:sliet_broadcast/core/viewmodels/base_model.dart';
import 'package:sliet_broadcast/utils/time_ago.dart';

class NoticeBaseModel extends BaseModel implements InterestBookmark {
  NoticeService _noticeService;

  NoticeType _noticeType = NoticeType.Public;

  String path;

  Timer _listen;

  NoticesList _noticesList = NoticesList();

  NoticesList _newNotice = NoticesList();

  NoticeBaseModel(
    NoticeService noticeService, {
    NoticeType noticeType = NoticeType.Public,
    String path = "/public/notice",
  })  : _noticeService = noticeService,
        _noticeType = noticeType,
        path = path;

  List<Notice> get notices => _noticesList.results;

//  bool get hasNotice =>
//      _noticesList.results != null && _noticesList.results.length != 0;

  bool get hasNotice => _hasNotice(_noticesList);

  bool get hasNewNotice => _hasNotice(_newNotice);

  get lastFetched => timeAgo(_noticesList.lastFetch);

  Future<void> _getNotice() async {
    setBusy();
    _noticesList = await _noticeService.getNotice(path: path);
    _noticesList.lastFetch = DateTime.now();
    setBusy(value: false);
  }

  Future<void> getNotice() async {
    setBusy();
    bool status = await _checkNotice();
    if (status) {
      _noticesList = _getNoticeFromService();
      setBusy(value: false);
      _loadNewNotice();
    } else {
      await _getNotice();
    }
    setBusy(value: false);
    if (!status) _setNoticeToService();
    setBusy(value: false);
    _listen = Timer.periodic(Duration(seconds: 70), (t) => listen());
  }

  Future<void> refreshNotice() async {
    setBusy();
    await _getNotice();
    setBusy(value: false);
  }

  @override
  Future<void> bookmark(Notice notice) async {
    setBusy();
    notice = await _noticeService.bookmark(notice, _noticeType);
    getNoticeAndUpdate(notice);
  }

  @override
  Future<void> interested(Notice notice) async {
    setBusy();
    notice = await _noticeService.interested(notice, _noticeType);
    getNoticeAndUpdate(notice);
  }

  @override
  Future<void> updateNotice(Notice notice) async {
    setBusy();
    notice = await _noticeService.getNoticeById(notice, _noticeType);
    getNoticeAndUpdate(notice);
  }

  // update all of notices in the notice_service
  getNoticeAndUpdate(Notice notice) {
    _noticesList = _getNoticeFromService();
    setBusy(value: false);
    _noticeService.updateAllNoticeList(notice, _noticeType);
  }

  Future<bool> _checkNotice() async {
    switch (_noticeType) {
      case NoticeType.Public:
        return _hasNotice(_noticeService.publicNotice);
      case NoticeType.Private:
        return _hasNotice(_noticeService.privateNotice);
      case NoticeType.Published:
        return _hasNotice(_noticeService.publishedNotice);
      case NoticeType.Bookmark:
        return _hasNotice(_noticeService.bookmarkedNotice);
      case NoticeType.Interested:
        return _hasNotice(_noticeService.interestedNotice);
    }
    return false;
  }

  bool _hasNotice(NoticesList _t) =>
      _t != null && _t.results != null && _t.results.length != 0;

  NoticesList _getNoticeFromService() {
    switch (_noticeType) {
      case NoticeType.Public:
        return _noticeService.publicNotice;
      case NoticeType.Private:
        return _noticeService.privateNotice;
      case NoticeType.Published:
        return _noticeService.publishedNotice;
      case NoticeType.Bookmark:
        return _noticeService.bookmarkedNotice;
      case NoticeType.Interested:
        return _noticeService.interestedNotice;
    }
    return null;
  }

  void _setNoticeToService() {
    switch (_noticeType) {
      case NoticeType.Public:
        _noticeService.publicNotice = _noticesList;
        break;
      case NoticeType.Private:
        _noticeService.privateNotice = _noticesList;
        break;
      case NoticeType.Published:
        _noticeService.publishedNotice = _noticesList;
        break;
      case NoticeType.Bookmark:
        _noticeService.bookmarkedNotice = _noticesList;
        break;
      case NoticeType.Interested:
        _noticeService.interestedNotice = _noticesList;
        break;
    }
  }

  void loadMoreNotice() async {
    setBusy();
    try {
      String last = _noticesList.notices.last.datetime;
      var _notice = await _noticeService.getNotice(path: path, query: {
        'after': last,
      });
      _noticesList.notices.addAll(_notice.notices);
      setBusy(value: false);
      _setNoticeToService();
    } catch (err) {}
    setBusy(value: false);
    _loadNewNotice();
  }

  void _loadNewNotice() async {
    setBusy();
    try {
      String first = _noticesList.notices.first.datetime;
      _newNotice = await _noticeService.getNotice(path: path, query: {
        'before': first,
      });
    } catch (err) {}
    setBusy(value: false);
  }

  Future<void> loadNewNotice() async {
    setBusy();
    _noticesList.notices.insertAll(0, _newNotice.notices);
    setBusy();
    _newNotice.notices.clear();
    _noticesList.lastFetch = DateTime.now();
    setBusy(value: false);
  }

  @override
  void dispose() {
    _listen?.cancel();
    super.dispose();
  }
}

abstract class InterestBookmark {
  Future<void> bookmark(Notice notice);

  Future<void> interested(Notice notice);

  Future<void> updateNotice(Notice notice);
}
