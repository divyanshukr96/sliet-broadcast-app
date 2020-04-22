import 'package:sliet_broadcast/core/constant.dart';
import 'package:sliet_broadcast/core/services/notice_service.dart';
import 'package:sliet_broadcast/core/viewmodels/notice_base_model.dart';

class PublicNoticeModel extends NoticeBaseModel {
  PublicNoticeModel({
    NoticeService noticeService,
  }) : super(
          noticeService = noticeService,
          noticeType: NoticeType.Public,
          path: "/public/notice",
        );

  getNotice() async {
    super.getNotice();
  }
}
