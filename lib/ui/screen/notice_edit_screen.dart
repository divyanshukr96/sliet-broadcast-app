import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliet_broadcast/ui/widgets/edit_notice.dart';
import 'package:sliet_broadcast/core/models/notice_list.dart';
import 'package:sliet_broadcast/core/viewmodels/views/notice_create_model.dart';
import 'package:sliet_broadcast/views/base_widget.dart';

class NoticeEditScreen extends StatelessWidget {
  final Notice notice;

  const NoticeEditScreen({@required this.notice});

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      model: NoticeCreateModel(noticeService: Provider.of(context)),
      onModelReady: (NoticeCreateModel model) => model.getDepartments(),
      builder: (context, NoticeCreateModel model, _) {
        return EditNotice(notice: notice, model: model);
      },
    );
  }
}
