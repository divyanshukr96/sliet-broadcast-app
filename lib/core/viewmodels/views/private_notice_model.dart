import 'package:sliet_broadcast/core/constant.dart';
import 'package:sliet_broadcast/core/services/notice_service.dart';
import 'package:sliet_broadcast/core/viewmodels/notice_base_model.dart';

class PrivateNoticeModel extends NoticeBaseModel {
  PrivateNoticeModel({
    NoticeService noticeService,
  }) : super(
          noticeService = noticeService,
          noticeType: NoticeType.Private,
          path: "/private/notice",
        );

  getNotice() async {
    super.getNotice();
  }
}
