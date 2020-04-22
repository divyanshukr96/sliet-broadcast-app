import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliet_broadcast/core/constant.dart';
import 'package:sliet_broadcast/core/viewmodels/views/notice_create_model.dart';
import 'package:sliet_broadcast/ui/widgets/create_notice.dart';
import 'package:sliet_broadcast/ui/widgets/notice_card.dart';
import 'package:sliet_broadcast/views/base_widget.dart';

class NoticeCreateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      model: NoticeCreateModel(noticeService: Provider.of(context)),
      onModelReady: (NoticeCreateModel model) {
        model.getDepartments();
      },
      builder: (context, NoticeCreateModel model, _) {
        if (model.uploaded && model.notice != null) {
          return NoticeUploaded(model);
        }
        return CreateNotice(model);
      },
    );
  }
}

class NoticeUploaded extends StatelessWidget {
  final NoticeCreateModel _model;

  NoticeUploaded(NoticeCreateModel model) : _model = model;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(gradient: LoginLinearGradient()),
      child: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.all(1.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.green),
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                  child: Text(
                    'Notice successfully uploaded to SLIET.',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
                RaisedButton(
                  onPressed: _model.clear,
                  child: Text('Create New Notice'),
                ),
                NoticeCard(_model.notice, _model),
                SizedBox(height: 16.0)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
