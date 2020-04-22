import 'package:sliet_broadcast/core/constant.dart';
import 'package:sliet_broadcast/core/services/notice_service.dart';
import 'package:sliet_broadcast/core/viewmodels/notice_base_model.dart';

class PublishedNoticeModel extends NoticeBaseModel {
  PublishedNoticeModel({
    NoticeService noticeService,
  }) : super(
          noticeService = noticeService,
          noticeType: NoticeType.Published,
          path: "/notice/",
        );

  getNotice() async {
    super.getNotice();
  }
}
