import 'dart:core';

class CardModelData {
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
  List departments;
  final imageList;

  CardModelData(
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
      this.departments,
      this.imageList);
}
