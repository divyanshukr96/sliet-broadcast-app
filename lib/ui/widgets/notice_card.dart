import 'package:cache_image/cache_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:sliet_broadcast/ui/widgets/button/custom_button.dart';
import 'package:sliet_broadcast/core/models/notice_list.dart';
import 'package:sliet_broadcast/components/notice_image_view_wrapper.dart';
import 'package:sliet_broadcast/core/viewmodels/notice_base_model.dart';
import 'package:sliet_broadcast/ui/routes.dart';
import 'package:sliet_broadcast/ui/screen/notice_edit_screen.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class NoticeCard extends StatefulWidget {
  final Notice notice;
  final InterestBookmark provider;

  NoticeCard(this.notice, this.provider) : super(key: Key(notice.id));

  @override
  _NoticeCardState createState() => _NoticeCardState(notice);
}

class _NoticeCardState extends State<NoticeCard> {
  Notice notice;

  _NoticeCardState(this.notice);

  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    TextStyle _body2Style = Theme.of(context).textTheme.body2;
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            NoticeCardHeader(notice: notice, button: _buildEditButton),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                notice.title,
                textAlign: TextAlign.start,
                style: _body2Style.copyWith(fontSize: 16.0),
              ),
            ),
            buildNoticeDescription(),
            SizedBox(height: 8.0),
            noticeImages(),
            SizedBox(height: 6.0),
            EventTime(notice: notice),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _interestButton,
                _moreButton,
                _bookmarkButton,
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget get _moreButton => SizedBox(
        width: 36,
        child: notice.images != null
            ? CustomIconButton(
                child: InkWell(
                  onTap: changeLines,
                  child: Icon(_moreLessIcons()),
                ),
              )
            : null,
      );

  IconData _moreLessIcons() {
    return expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down;
  }

  Widget get _interestButton => SizedBox(
        width: 36,
        child: notice.isEvent
            ? CustomIconButton(
                child: Tooltip(
                  message: 'Interested',
                  child: InkWell(
                    child: Icon(
                      Icons.pan_tool,
                      color: notice.interested ? Colors.green : Colors.black54,
                    ),
                    onTap: () async {
                      await widget.provider.interested(notice);
                    },
                  ),
                ),
              )
            : null,
      );

  Widget get _buildEditButton => Builder(
        builder: (context) {
          if (notice.canEdit) {
            return Container(
              height: 36,
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: InkResponse(
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => NoticeEditScreen(
                            notice: notice,
                          ),
                        ),
                      );
                      await widget.provider.updateNotice(notice);
                    },
                    radius: 16.0,
                    splashColor: Colors.lightBlue,
                    child: IconTheme.merge(
                      data: IconThemeData(size: 18.0, color: Colors.grey),
                      child: Icon(Icons.edit),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return SizedBox(height: 0.0);
          }
        },
      );

  Widget get _bookmarkButton => Align(
        alignment: Alignment.centerRight,
        child: CustomIconButton(
          child: Tooltip(
            message: 'Bookmark',
            child: InkWell(
              child: Icon(
                notice.bookmark ? Icons.bookmark : Icons.bookmark_border,
                color: notice.bookmark ? Colors.blue : Colors.black54,
              ),
              onTap: () async {
                await widget.provider.bookmark(notice);
              },
            ),
          ),
        ),
      );

  Widget buildNoticeDescription() {
    final _style = Theme.of(context).textTheme.body1;

    if (notice.description == null || notice.description == "") {
      return SizedBox(height: 0.0);
    }

    final words = notice.description.split(' ');
    List<TextSpan> span = [];

    words.forEach((word) {
      span.add(_isLink(word)
          ? LinkTextSpan(
              text: '$word ',
              url: _generateLink(word),
              style: _style.copyWith(color: Colors.blue),
            )
          : TextSpan(text: '$word ', style: _style));
    });

    return RichText(text: TextSpan(children: span));
  }

  String _generateLink(String word) {
    RegExp exp = RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
    Iterable<RegExpMatch> matches = exp.allMatches(word);
    matches.forEach((match) {
      word = word.substring(match.start, match.end);
    });
    return word;
  }

  Widget noticeImages() {
    return expanded
        ? Container(
            height: MediaQuery.of(context).size.height * .4,
            child: Stack(
              children: <Widget>[
                PhotoViewGallery.builder(
                  itemCount: notice.images.length,
                  builder: (context, index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider: CacheImage(notice.images[index]),
                      minScale: PhotoViewComputedScale.contained * 1,
                      maxScale: PhotoViewComputedScale.covered * 3,
                      heroAttributes: PhotoViewHeroAttributes(
                        tag: notice.images[index],
                      ),
                    );
                  },
                  scrollPhysics: BouncingScrollPhysics(),
                  loadingChild: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                Positioned(
                  child: IconButton(
                    onPressed: fullScreen,
                    icon: Icon(Icons.fullscreen),
                    color: Colors.white,
                  ),
                  right: 0,
                  top: 0,
                )
              ],
            ),
          )
        : SizedBox(height: 0);
  }

  void changeLines() => setState(() {
        expanded = !expanded;
      });

  void fullScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NoticePhotoViewWrapper(
          noticeImages: notice.images,
          noticeTitle: notice.title,
        ),
      ),
    );
  }

  bool _isLink(String input) {
    final matcher = RegExp(
        r"(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)");
    return matcher.hasMatch(input);
  }
}

class LinkTextSpan extends TextSpan {
  LinkTextSpan({
    TextStyle style,
    String url,
    String text,
  }) : super(
          style: style,
          text: text ?? url,
          recognizer: TapGestureRecognizer()
            ..onTap = () => launcher.launch(url),
        );
}

class NoticeCardHeader extends StatelessWidget {
  const NoticeCardHeader({
    Key key,
    @required this.notice,
    this.button,
  }) : super(key: key);

  final Notice notice;
  final Widget button;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      //mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          backgroundImage: notice.profile != null
              ? CacheImage(notice.profile)
              : AssetImage('assets/images/login.png'),
          radius: 18.0,
          backgroundColor: Colors.black, //TODO change this to backgroundImage
        ),
        SizedBox(width: 6.0),
        Expanded(
          flex: 25,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  await Navigator.pushNamedAndRemoveUntil(
                    context,
                    RoutePath.ChannelDetails,
                    (route) => route.isFirst,
                    arguments: notice.userId,
                  );
                },
                child: Text(
                  notice.user,
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                notice.createdAt,
                style: TextStyle(fontSize: 11.0),
              ),
            ],
          ),
        ),
        button
      ],
    );
  }
}

//class NoticeEditButton extends StatelessWidget {
//  const NoticeEditButton({
//    Key key,
//    @required this.notice,
//    @required this.provider,
//  }) : super(key: key);
//
//  final Notice notice;
//  final InterestBookmark provider;
//
//  // TODO add here multiple button
//  @override
//  Widget build(BuildContext context) {
//    if (notice.canEdit)
//      return Container(
//        height: 36,
//        child: Align(
//          alignment: Alignment.topLeft,
//          child: Padding(
//            padding: const EdgeInsets.only(left: 10.0),
//            child: InkResponse(
//              onTap: () async {
//                var data = await Navigator.of(context).push(
//                  MaterialPageRoute(
//                    builder: (BuildContext context) => NoticeEditScreen(
//                      notice: notice,
//                    ),
//                  ),
//                );
//                if (data != null) {
////                  provider.updateNotice(data);
//                  provider.updateNotice(data);
//                }
//              },
//              radius: 16.0,
//              splashColor: Colors.lightBlue,
//              child: IconTheme.merge(
//                data: IconThemeData(size: 18.0, color: Colors.grey),
//                child: Icon(Icons.edit),
//              ),
//            ),
//          ),
//        ),
//      );
//    else
//      return SizedBox(height: 0.0);
//  }
//}

class EventTime extends StatelessWidget {
  const EventTime({
    Key key,
    @required this.notice,
  }) : super(key: key);

  final Notice notice;

  @override
  Widget build(BuildContext context) {
    if (notice.date != null || notice.venue != null) {
      String eventTime = "- - - - - - - -";
      if (notice.date != null) {
        eventTime = notice.date;
        if (notice.time != null) eventTime += ", " + notice.time;
      }
      return Padding(
        padding: EdgeInsets.only(bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Text(
                    'DATE & TIME',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1976D2),
                    ),
                  ),
                  Text(eventTime),
                ],
              ),
            ),
            Container(
              height: 35.0,
              width: 1.0,
              color: Colors.orange,
              margin: const EdgeInsets.only(left: 10.0, right: 10.0),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Text(
                    'VENUE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1976D2),
                    ),
                  ),
                  Text(notice.venue ?? "- - - - - -"),
                ],
              ),
            ),
          ],
        ),
      );
    } else
      return SizedBox(height: 0, width: 0);
  }
}
