import 'package:sliet_broadcast/provider/noticeHelper.dart';

class PublicNoticeNotifier extends NoticeNotifier {
  PublicNoticeNotifier() : super(path: '/v1/public/notice'); //TODO TODO remove v1 from here
}
