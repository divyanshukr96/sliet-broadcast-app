import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sliet_broadcast/components/edit_notice.dart';
import 'package:sliet_broadcast/components/models/notice.dart';
import 'package:sliet_broadcast/utils/carousel.dart';

class NoticeCard extends StatefulWidget {
  final Notice cardModelData;

  NoticeCard(this.cardModelData);

  @override
  _NoticeCardState createState() => _NoticeCardState(cardModelData);
}

class _NoticeCardState extends State<NoticeCard> {
  Notice notice;

  _NoticeCardState(this.notice);

  int numberOfLines = 3;

  var iconForText = Icon(
    Icons.keyboard_arrow_down,
  );

  var imageForCard;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              NoticeCardHeader(notice: notice),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  notice.titleOfEvent,
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              Container(
                child: imageForCard,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  notice.aboutEvent,
                  overflow: TextOverflow.ellipsis,
                  maxLines: numberOfLines,
                ),
              ),
              EventTime(notice: notice),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: changeLines,
                    child: iconForText,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void changeLines() {
    if ((numberOfLines == 3) && (notice.imageUrlNotice != null)) {
      numberOfLines = 1000;
      iconForText = Icon(
        Icons.keyboard_arrow_up,
      );

      imageForCard = Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: CarouselSlider(
          height: MediaQuery.of(context).size.height * .6,
          aspectRatio: MediaQuery.of(context).size.aspectRatio,
          viewportFraction: 1.0,
          items: notice.imageUrlNotice.map((image) {
            return Builder(
              builder: (BuildContext context) {
                return PhotoView(imageProvider: NetworkImage(image));
              },
            );
          }).toList(),
        ),
      );
    } else if (numberOfLines == 3) {
      numberOfLines = 1000;
      iconForText = Icon(
        Icons.keyboard_arrow_up,
      );
    } else {
      numberOfLines = 3;
      iconForText = Icon(
        Icons.keyboard_arrow_down,
      );
      imageForCard = null;
    }
    setState(() {
      numberOfLines = numberOfLines;
    });
  }
}

class NoticeCardHeader extends StatelessWidget {
  const NoticeCardHeader({
    Key key,
    @required this.notice,
  }) : super(key: key);

  final Notice notice;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      //mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CircleAvatar(
          backgroundImage: notice.userProfile != null
              ? NetworkImage(notice.userProfile)
              : AssetImage('assets/images/login.png'),
          radius: 25.0,
          backgroundColor: Colors.black, //change this to backgroundImage
        ),
        Expanded(
          flex: 25,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  notice.nameOfUploader,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  notice.dateOfNoticeUpload,
                  style: TextStyle(fontSize: 11.0),
                ),
              ],
            ),
          ),
        ),
        NoticeEditButton(notice: notice),
      ],
    );
  }
}

class NoticeEditButton extends StatelessWidget {
  const NoticeEditButton({
    Key key,
    @required this.notice,
  }) : super(key: key);

  final Notice notice;

  @override
  Widget build(BuildContext context) {
    if (notice.caEditNotice)
      return Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: InkResponse(
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => EditNotice(
                    notice: notice,
                  ),
                ),
              );
            },
            radius: 16.0,
            splashColor: Colors.lightBlue,
            child: IconTheme.merge(
              data: IconThemeData(size: 18.0, color: Colors.grey),
              child: Icon(Icons.edit),
            ),
          ),
        ),
      );
    else
      return SizedBox(height: 0.0);
  }
}

class EventTime extends StatelessWidget {
  const EventTime({
    Key key,
    @required this.notice,
  }) : super(key: key);

  final Notice notice;

  @override
  Widget build(BuildContext context) {
    if (notice.dateOfEvent != null || notice.venueForEvent != null) {
      String eventTime = "- - - - - - - -";
      if (notice.dateOfEvent != null) {
        eventTime = notice.dateOfEvent;
        if (notice.timeOfEvent != null) eventTime += ", " + notice.timeOfEvent;
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Text('DATE & TIME',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1976D2),
                    )),
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
                Text(notice.venueForEvent ?? "- - - - - -"),
              ],
            ),
          ),
        ],
      );
    } else
      return SizedBox(
        height: 0,
        width: 0,
      );
  }
}
