import 'package:sliet_broadcast/components/models/notice.dart';

class Notices {
  final List<Notice> notices;
  final int totalNotices;
  final int pageNumber;
  final int pageSize;
  dynamic nextPage;
  dynamic previousPage;
  dynamic lastNotice;
  dynamic firstNotice;

  Notices({
    this.notices,
    this.totalNotices,
    this.pageNumber,
    this.pageSize,
    this.nextPage,
    this.previousPage,
  });

  Notices.fromMap(dynamic map)
      : notices = List<Notice>.from(
          map['results'].map((notice) => Notice.fromMap(notice)),
        ),
        totalNotices = map['count'],
        pageNumber = map[''],
        pageSize = map[''],
        nextPage = map['next'],
        previousPage = map['previous'];
}
