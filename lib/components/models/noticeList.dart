import 'package:sliet_broadcast/components/models/notice.dart';

class Notices {
  final List<Notice> notices;
  final int totalNotices;
  final int pageNumber;
  final int pageSize;

  Notices({
    this.notices,
    this.totalNotices,
    this.pageNumber,
    this.pageSize,
  });

  Notices.fromMap(Map<dynamic, dynamic> map)
      : notices = List<Notice>.from(
          map['notices'].map((notice) => Notice.fromMap(notice)),
        ),
        totalNotices = map['t'],
        pageNumber = map[''],
        pageSize = map[''];
}
