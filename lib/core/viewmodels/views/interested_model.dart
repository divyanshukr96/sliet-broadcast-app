import 'package:sliet_broadcast/core/constant.dart';
import 'package:sliet_broadcast/core/services/notice_service.dart';
import 'package:sliet_broadcast/core/viewmodels/notice_base_model.dart';

class InterestedModel extends NoticeBaseModel {
  InterestedModel({
    NoticeService noticeService,
  }) : super(
          noticeService = noticeService,
          noticeType: NoticeType.Interested,
          path: "/interested/",
        );

  getNotice() async {
    super.getNotice();
  }
}
