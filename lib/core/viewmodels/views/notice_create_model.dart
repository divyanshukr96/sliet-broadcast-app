import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:sliet_broadcast/core/models/department.dart';
import 'package:sliet_broadcast/core/models/notice_list.dart';
import 'package:sliet_broadcast/core/services/notice_service.dart';
import 'package:sliet_broadcast/core/viewmodels/base_model.dart';
import 'package:sliet_broadcast/core/viewmodels/notice_base_model.dart';

class NoticeCreateModel extends BaseModel implements InterestBookmark {
  NoticeService _noticeService;

  int _percentage = 0;
  bool _uploadStatus = false;
  Notice _notice;

  List<Department> departments = List<Department>();

  NoticeCreateModel({
    @required NoticeService noticeService,
  }) : _noticeService = noticeService;

  int get percentage => _percentage;

  bool get uploaded => _uploadStatus;

  Notice get notice => _notice;

  void getDepartments() async {
    setBusy();
    try {
      Response response = await _noticeService.get(path: '/departments');
      departments = List<Department>.from(
        response.data.map((dept) => Department.fromJson(dept)),
      );
    } catch (err) {
      print('NoticeCreateModel getDepartments Error : $err');
    }
    setBusy(value: false);
  }

  Future<dynamic> createNotice({FormData data}) async {
    _percentage = 0;
    Response response = await _noticeService.createNotice(
      data: data,
      onSendProgress: (int count, int total) {
        _percentage = ((count / total) * 100).toInt();
        notifyListeners();
      },
    );
    await Future.delayed(const Duration(seconds: 1));
    _notice = Notice.fromJson(response.data);
    _uploadStatus = true;
    setBusy(value: false);
  }

  Future<dynamic> patchNotice(Notice notice, {FormData data}) async {
    _percentage = 0;
    try {
      _notice = await _noticeService.patchNotice(
        notice,
        data: data,
        onSendProgress: (int count, int total) {
          _percentage = ((count / total) * 100).toInt();
          notifyListeners();
        },
      );
      _noticeService.updateAllNoticeList(_notice, null);
      _uploadStatus = true;
      setBusy(value: false);
    } catch (err) {
      _percentage = 0;
      setBusy(value: false);
      throw err;
    }
  }

  Future deleteImage(String noticeId, String imageId) async {
    return await _noticeService.delete(
      path: '/notice/$noticeId/image/$imageId',
    );
  }

  @override
  Future<void> bookmark(Notice notice) {
    // TODO: implement bookmark
    return null;
  }

  @override
  Future<void> interested(Notice notice) {
    // TODO: implement interested
    return null;
  }

  @override
  Future<void> updateNotice(Notice notice) {
    // TODO: implement updateNotice
    return null;
  }

  void clear() {
    _notice = null;
    _uploadStatus = false;
    notifyListeners();
  }
}
