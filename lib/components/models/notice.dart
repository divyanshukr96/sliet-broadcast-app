import 'dart:core';

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
        dateOfNoticeUpload = map['created_at'];
}
