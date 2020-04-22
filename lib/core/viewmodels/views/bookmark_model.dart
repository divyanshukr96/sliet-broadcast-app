import 'package:sliet_broadcast/core/constant.dart';
import 'package:sliet_broadcast/core/services/notice_service.dart';
import 'package:sliet_broadcast/core/viewmodels/notice_base_model.dart';

class BookmarkModel extends NoticeBaseModel {
  BookmarkModel({
    NoticeService noticeService,
  }) : super(
          noticeService = noticeService,
          noticeType: NoticeType.Bookmark,
          path: "/bookmark/",
        );

  getNotice() async {
    super.getNotice();
  }
}
