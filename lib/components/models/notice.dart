import 'dart:core';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:sliet_broadcast/utils/network_utils.dart';
import 'package:sliet_broadcast/utils/toast.dart';

class Notice {
  String id;
  String nameOfUploader;
  String userProfile;
  String titleOfEvent;
  String dateOfNoticeUpload;
  String timeOfNoticeUpload;
  List imageUrlNotice;
  final isEvent;
  String venueForEvent;
  String timeOfEvent;
  String dateOfEvent;
  String aboutEvent;
  final public;
  final visible;
  List departments;
  final imageList;
  final caEditNotice;
  bool bookmark;
  final dateTime;

  Notice({
    this.id,
    this.nameOfUploader,
    this.userProfile,
    this.titleOfEvent,
    this.dateOfNoticeUpload,
    this.imageUrlNotice,
    this.isEvent,
    this.venueForEvent,
    this.timeOfEvent,
    this.dateOfEvent,
    this.aboutEvent,
    this.public,
    this.visible,
    this.departments,
    this.imageList,
    this.caEditNotice,
    this.bookmark,
    this.dateTime,
  });

  Notice.fromMap(Map<dynamic, dynamic> map)
      : id = map['id'],
        nameOfUploader = map['user'],
        userProfile = map['profile'],
        titleOfEvent = map['title'],
        aboutEvent = map['description'],
        isEvent = map['is_event'],
        venueForEvent = map['venue'],
        timeOfEvent = map['time'],
        dateOfEvent = map['date'],
        public = map['public_notice'],
        visible = map['visible'],
        departments = map['department'],
        imageUrlNotice = map['images'],
        imageList = map['images_list'],
        caEditNotice = map['can_edit'],
        bookmark = map['bookmark'],
        dateTime = map['datetime'],
        dateOfNoticeUpload = map['created_at'];

  Future<bool> setBookmark({BuildContext context}) async {
    Dio _dio = new Dio();
    Response response;
    String token = await NetworkUtils.getTokenStatic();
    if (token == null || token == "") return bookmark;
    _dio.options.headers['Authorization'] = "Token " + token;
    try {
      response = await _dio.patch(NetworkUtils.host + '/api/bookmark/$id/');
      if (response.statusCode == 200) {
        if (context is BuildContext)
          Toast.show(
            response.data['success'],
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
          );
        bookmark = !bookmark;
      }
    } catch (e) {}
    return bookmark;
  }
}
