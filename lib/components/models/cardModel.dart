import 'dart:core';

class CardModelData {
  String id;
  String nameOfUploader;
  String userProfile;
  String titleOfEvent;
  String dateOfNoticeUpload;
  String timeOfNoticeUpload;
  List imageUrlNotice;
  String timeOfEvent;
  String dateOfEvent;
  String venueForEvent;
  String aboutEvent;

  CardModelData(
      this.id,
      this.nameOfUploader,
      this.userProfile,
      this.titleOfEvent,
      this.dateOfNoticeUpload,
      this.timeOfNoticeUpload,
      this.imageUrlNotice,
      this.timeOfEvent,
      this.dateOfEvent,
      this.venueForEvent,
      this.aboutEvent);
}
