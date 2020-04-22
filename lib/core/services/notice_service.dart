import 'dart:async';

import 'package:dio/dio.dart';
import 'package:sliet_broadcast/core/models/notice_list.dart';
import 'package:sliet_broadcast/core/constant.dart';
import 'package:sliet_broadcast/core/services/api.dart';

class NoticeService {
  Api _api;

  NoticesList publicNotice;
  NoticesList privateNotice;
  NoticesList publishedNotice;
  NoticesList bookmarkedNotice;
  NoticesList interestedNotice;

  NoticeService({Api api}) : _api = api;

  Future<Response> get({String path, Map<String, dynamic> query}) async {
    return await _api.get(path: path, query: query);
  }

  Future<Response> post({String path}) async {
    return await _api.post(path: path);
  }

  Future<Response> patch({String path}) async {
    return await _api.patch(path: path);
  }

  Future<NoticesList> getNotice({
    String path,
    Map<String, dynamic> query,
  }) async {
    try {
      Response response = await get(path: path, query: query);
      return NoticesList.fromJson(response.data);
    } catch (err) {}
    return NoticesList();
  }

  Future<Notice> getNoticeById(Notice notice, NoticeType type) async {
    try {
      Response response = await _api.get(path: '/notice/${notice.id}');
      Notice _notice = Notice.fromJson(response.data);
      notice.title = _notice.title;
      notice.description = _notice.description;
      notice.isEvent = _notice.isEvent;
      notice.date = _notice.date;
      notice.time = _notice.time;
      notice.venue = _notice.venue;
      notice.visible = _notice.visible;
      notice.publicNotice = _notice.publicNotice;
      notice.images = _notice.images;
      notice.imagesList = _notice.imagesList;
      notice.department = _notice.department;
      notice.allDepartment = _notice.allDepartment;
      _updateNoticeList(type, notice);
    } catch (err) {
      print('NoticeService getNoticeById : $err');
    }
    return notice;
  }

  Future<Notice> bookmark(Notice notice, NoticeType type) async {
    try {
      Response response = await _api.patch(path: '/bookmark/${notice.id}/');
      notice.bookmark = response.data['status'];
      _updateNoticeList(type, notice);
    } catch (err) {
      print('NoticeService bookmark : $err');
    }
    return notice;
  }

  Future<Notice> interested(Notice notice, NoticeType type) async {
    try {
      Response response = await _api.patch(path: '/bookmark/${notice.id}/');
      notice.interested = response.data['status'];
      _updateNoticeList(type, notice);
    } catch (err) {
      print('NoticeService interested : $err');
    }
    return notice;
  }

  _updateNoticeList(NoticeType type, Notice notice) {
    bool avail = false;
    final callback = (Notice V) {
      if (V.id == notice.id) {
        V = notice;
        avail = true;
      }
      return V;
    };
    try {
      switch (type) {
        case NoticeType.Public:
          publicNotice.results = publicNotice.results.map(callback).toList();
          break;
        case NoticeType.Private:
          privateNotice.results = privateNotice.results.map(callback).toList();
          break;
        case NoticeType.Published:
          publishedNotice.results =
              publishedNotice.results.map(callback).toList();
          break;
        case NoticeType.Bookmark:
          try {
            bookmarkedNotice.results = bookmarkedNotice.results
                .map(callback)
                .where((Notice V) => V.bookmark)
                .toList();
          } catch (err) {} finally {
            if (!avail) {
              bookmarkedNotice = _addToNoticeList(bookmarkedNotice, notice);
            }
          }
          break;
        case NoticeType.Interested:
          try {
            interestedNotice.results = interestedNotice.results
                .map(callback)
                .where((Notice V) => V.interested)
                .toList();
          } catch (err) {} finally {
            if (!avail) {
              interestedNotice = _addToNoticeList(interestedNotice, notice);
            }
          }
          break;
      }
    } catch (err) {}
  }

  void updateAllNoticeList(Notice notice, NoticeType noticeType) {
    List<NoticeType> type = NoticeType.values.where((NoticeType V) {
      return V != noticeType;
    }).toList();
    type.forEach((_noticeType) {
      try {
        _updateNoticeList(_noticeType, notice);
      } catch (err) {}
    });
  }

  NoticesList _addToNoticeList(NoticesList noticesList, Notice notice) {
    if (noticesList == null) noticesList = NoticesList();
    noticesList.results.insert(0, notice);
    return noticesList;
  }

  Future<Response> createNotice({data, ProgressCallback onSendProgress}) async {
    RequestOptions __options = RequestOptions(
      headers: {
        "content-type": "application/x-www-form-urlencoded",
      },
    );
    __options.onSendProgress = onSendProgress;
    return await _api.post(
      path: '/notice/',
      data: data,
      options: __options,
    );
  }

  Future<Notice> patchNotice(
    Notice notice, {
    data,
    ProgressCallback onSendProgress,
  }) async {
    RequestOptions __options = RequestOptions(
      headers: {
        "content-type": "application/x-www-form-urlencoded",
      },
    );
    __options.onSendProgress = onSendProgress;
    try {
      Response response = await _api.patch(
        path: '/notice/${notice.id}/',
        data: data,
        options: __options,
      );
      notice = Notice.fromJson(response.data);
      try {
        publishedNotice = _addToNoticeList(publishedNotice, notice);
      } catch (err) {
        print('delayed errot : $err');
      }
      return notice;
    } catch (err) {
      throw err;
    }
  }

  Future delete({String path}) async {
    return await _api.delete(path: path);
  }
}

//  void updateAllBookmarks(Notice notice, NoticeType noticeType) {
//    List<NoticeType> type =
//        NoticeType.values.where((NoticeType V) => V != noticeType).toList();
//    type.forEach((_noticeType) {
//      _updateNoticeList(_noticeType, (Notice V) {
//        if (V.id == notice.id) {
//          V.bookmark = notice.bookmark;
//        }
//        return V;
//      });
//    });
//  }
