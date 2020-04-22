import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sliet_broadcast/core/models/notice_list.dart';

class NoticeJsonStorage {
  Directory _dir;

  String _path;

  String _filename;

  bool _fileExists = false;

//  NoticeJsonStorage([NoticeType type]) {
//    _filename = (type ?? NoticeType.Public).toString();
//  }

  String get fileName => _filename;

  dynamic _getPath() async {
    try {
      _dir = await getTemporaryDirectory();
      _path = _dir.path + "/notices";
    } catch (e) {
      print('jsonstorage _getpath Error $e');
    }
  }

  Future<File> _createJsonFile(File file) async {
    file.createSync();
    file.writeAsStringSync(jsonEncode({
      'createdAt': DateTime.now().toString(),
    }));
    return file;
  }

  Future<File> _openJsonFile() async {
    if (_path == null) await _getPath();
    File _jsonFile = File(_path + '/$_filename.broadcast');
    _fileExists = _jsonFile.existsSync();
    if (_fileExists) {
      return _jsonFile;
    }
    try {
      return await _createJsonFile(_jsonFile);
    } on FileSystemException catch (e) {
      await Directory(_path).create(recursive: true);
      return await _createJsonFile(_jsonFile);
    }
  }

  Future<void> addNotice(resData) async {
    File _jsonFile = await _openJsonFile();
    var jsonData = _jsonFile.readAsStringSync();
    Map<String, dynamic> data = json.decode(jsonData);

    if (data['results'] != null) {
      DateTime first = DateTime.parse(data['results'].first['datetime']);
      List<dynamic> results = resData['results'].where((notice) {
        Duration diff = DateTime.parse(notice['datetime']).difference(first);
        return diff.inMicroseconds > 0;
      }).toList();

      data = {
        ...data,
        ...resData,
        'results': [...results, ...data['results']],
      };
    } else {
      data.addAll(resData);
    }
    _jsonFile.writeAsStringSync(json.encode(data));
  }

  Future<void> addMoreNotice(resData) async {
    File _jsonFile = await _openJsonFile();
    var jsonData = _jsonFile.readAsStringSync();
    Map<String, dynamic> data = json.decode(jsonData);

    if (data['results'] != null) {
      DateTime first = DateTime.parse(data['results'].last['datetime']);
      List<dynamic> results = resData['results'].where((notice) {
        Duration diff = DateTime.parse(notice['datetime']).difference(first);
        return diff.inMicroseconds <= 0;
      }).toList();

      data = {
        ...data,
        ...resData,
        'results': [...data['results'], ...results],
      };
    } else {
      data.addAll(resData);
    }
    _jsonFile.writeAsStringSync(json.encode(data));
  }

  getNotices() async {
    File _jsonFile = await _openJsonFile();
    var jsonData = _jsonFile.readAsStringSync();
    Map<String, dynamic> data = json.decode(jsonData);
    return data;
  }

  Future<void> deleteNoticeFile() async {
    File _jsonFile = await _openJsonFile();
    _jsonFile.writeAsStringSync(jsonEncode({
      'createdAt': DateTime.now().toString(),
    }));
  }

//  void setBookmark(Notice notice, bool bookmark) async {
//    await _setBookmark(notice, bookmark);
//    Timer(Duration(microseconds: 1), () async {
//      switch (notice.noticeType) {
//        case NoticeType.Public:
//          await _setBookmark(notice, bookmark, NoticeType.Private);
//          await _setBookmark(notice, bookmark, NoticeType.Interested);
//          await _setBookmark(notice, bookmark, NoticeType.Bookmark);
//          break;
//        case NoticeType.Private:
//          await _setBookmark(notice, bookmark, NoticeType.Public);
//          await _setBookmark(notice, bookmark, NoticeType.Interested);
//          await _setBookmark(notice, bookmark, NoticeType.Bookmark);
//          break;
//        case NoticeType.Bookmark:
//          await _setBookmark(notice, bookmark, NoticeType.Public);
//          await _setBookmark(notice, bookmark, NoticeType.Private);
//          await _setBookmark(notice, bookmark, NoticeType.Interested);
//          break;
//        case NoticeType.Interested:
//          await _setBookmark(notice, bookmark, NoticeType.Public);
//          await _setBookmark(notice, bookmark, NoticeType.Private);
//          await _setBookmark(notice, bookmark, NoticeType.Bookmark);
//          break;
//      }
//    });
//  }

//  void setInterested(Notice notice, bool interested) async {
//    await _setInterested(notice, interested, NoticeType.Public);

//    Timer(Duration(microseconds: 1), () async {
//      switch (notice.noticeType) {
//        case NoticeType.Public:
//          await _setInterested(notice, interested, NoticeType.Private);
//          await _setInterested(notice, interested, NoticeType.Bookmark);
//          await _setInterested(notice, interested, NoticeType.Interested);
//          break;
//        case NoticeType.Private:
//          await _setInterested(notice, interested, NoticeType.Public);
//          await _setInterested(notice, interested, NoticeType.Bookmark);
//          await _setInterested(notice, interested, NoticeType.Interested);
//          break;
//        case NoticeType.Bookmark:
//          await _setInterested(notice, interested, NoticeType.Public);
//          await _setInterested(notice, interested, NoticeType.Private);
//          await _setInterested(notice, interested, NoticeType.Interested);
//          break;
//        case NoticeType.Interested:
//          await _setInterested(notice, interested, NoticeType.Public);
//          await _setInterested(notice, interested, NoticeType.Private);
//          await _setInterested(notice, interested, NoticeType.Bookmark);
//          break;
//      }
//    });
//  }

//  Future _setBookmark(Notice notice, bool bookmark, [NoticeType type]) async {
//    try {
//      _filename = (type ?? notice.noticeType).toString();
//      File _jsonFile = await _openJsonFile();
//      Map<String, dynamic> data = json.decode(_jsonFile.readAsStringSync());
//
//      dynamic results = data['results'].map((data) {
//        if (data['id'] == notice.id) {
//          data['bookmark'] = bookmark;
//        }
//        return data;
//      }).toList();
//
//      bool _isNotBookmark = NoticeType.Bookmark != notice.noticeType;
//      if (_isNotBookmark && bookmark && type == null) {
//        _addBookmarkOrInterest(
//          results.where((d) => d['id'] == notice.id).toList()[0],
//          NoticeType.Bookmark,
//        );
//      }
//
//      if ([NoticeType.Bookmark].contains(type ?? notice.noticeType)) {
//        results = results.where((d) => d['bookmark'] == true).toList();
//      }
//
//      data = {
//        ...data,
//        'results': results,
//      };
//      _jsonFile.writeAsStringSync(jsonEncode(data));
//    } catch (err) {
//      print('noticeJsonStorage _setBookmark Error $err');
//    }
//  }
//
//  Future _setInterested(Notice notice, bool interest, [NoticeType type]) async {
//    try {
//      _filename = (type ?? notice.noticeType).toString();
//      File _jsonFile = await _openJsonFile();
//      Map<String, dynamic> data = json.decode(_jsonFile.readAsStringSync());
//
//      dynamic results = data['results'].map((data) {
//        if (data['id'] == notice.id) {
//          data['interested'] = interest;
//        }
//        return data;
//      }).toList();
//
//      bool _isNotInterested = NoticeType.Interested != notice.noticeType;
//      if (_isNotInterested && interest && type == null) {
//        _addBookmarkOrInterest(
//          results.where((d) => d['id'] == notice.id).toList()[0],
//          NoticeType.Interested,
//        );
//      }
//
//      if ([NoticeType.Interested].contains(type ?? notice.noticeType)) {
//        results = results.where((d) => d['interested'] == true).toList();
//      }
//
//      data = {
//        ...data,
//        'results': results,
//      };
//      _jsonFile.writeAsStringSync(jsonEncode(data));
//    } catch (err) {
//      print('noticeJsonStorage _setInterest Error $err');
//    }
//  }

//  Future _addBookmarkOrInterest(dynamic notice, NoticeType noticeType) async {
//    try {
//      DateTime comp = DateTime.parse(notice['datetime']);
//      _filename = noticeType.toString();
//      File _jsonFile = await _openJsonFile();
//      Map<String, dynamic> data = json.decode(_jsonFile.readAsStringSync());
//      dynamic prev = [];
//      dynamic next = [];
//      if (data['results'] != null) {
//        data['results'].forEach((data) {
//          if (data['id'] == notice['id']) throw Error();
//          Duration diff = DateTime.parse(data['datetime']).difference(comp);
//          if (diff.inMicroseconds > 0) {
//            prev.add(data);
//          } else {
//            next.add(data);
//          }
//        });
//      }
//      data['results'] = [
//        ...prev,
//        notice,
//        ...next,
//      ];
//      _jsonFile.writeAsStringSync(jsonEncode(data));
//    } catch (err) {
//      print('noticeJsonStorage _addBookmarkOrInterest Error $err');
//    }
//  }

  void deleteDir() async {
//    final dir = Directory(_path);
//    await dir.delete(recursive: true);
  }

  void openDir() async {
//    final dir = Directory(_path);
//    print(dir.listSync()[0].runtimeType);
  }
}
