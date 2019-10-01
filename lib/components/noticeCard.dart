import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sliet_broadcast/components/edit_notice.dart';
import 'package:sliet_broadcast/components/models/cardModel.dart';
import 'package:sliet_broadcast/utils/carousel.dart';

class NoticeCard extends StatefulWidget {
  final CardModelData cardModelData;

  NoticeCard(this.cardModelData);

  @override
  _NoticeCardState createState() => _NoticeCardState(cardModelData);
}

class _NoticeCardState extends State<NoticeCard> {
  CardModelData cardModelData;

  _NoticeCardState(this.cardModelData);

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
              NoticeCardHeader(cardModelData: cardModelData),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  cardModelData.titleOfEvent,
                  textAlign: TextAlign.start,
                ),
              ),
              Container(
                child: imageForCard,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  cardModelData.aboutEvent,
                  overflow: TextOverflow.ellipsis,
                  maxLines: numberOfLines,
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              EventTime(cardModelData: cardModelData),
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
    if ((numberOfLines == 3) && (cardModelData.imageUrlNotice != null)) {
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
          items: cardModelData.imageUrlNotice.map((image) {
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
    @required this.cardModelData,
  }) : super(key: key);

  final CardModelData cardModelData;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      //mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CircleAvatar(
          backgroundImage: cardModelData.userProfile != null
              ? NetworkImage(cardModelData.userProfile)
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
                  cardModelData.nameOfUploader,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  cardModelData.dateOfNoticeUpload,
                  style: TextStyle(fontSize: 11.0),
                ),
              ],
            ),
          ),
        ),

        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: InkResponse(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => EditNotice(
                      notice: cardModelData,
                    ),
                  ),
                );
              },
              radius: 16.0,
              splashColor: Colors.lightBlue,
              child: IconTheme.merge(
                data: IconThemeData(
                  size: 18.0,
                  color: Colors.grey,
                ),
                child: Icon(Icons.edit),
              ),
            ),
          ),
        ),

//        Align(
//          alignment: Alignment.topLeft,
//          child: IconButton(
//            padding: EdgeInsets.all(0.0),
//            icon: Icon(Icons.edit),
//            color: Colors.grey,
//            onPressed: () {},
//          ),
//        ),

//        Spacer(),
//                    Column(
//                      crossAxisAlignment: CrossAxisAlignment.end,
//                      children: <Widget>[
//                        Text(cardModelData.timeOfNoticeUpload),
//                      ],
//                    ),
      ],
    );
  }
}

class EventTime extends StatelessWidget {
  const EventTime({
    Key key,
    @required this.cardModelData,
  }) : super(key: key);

  final CardModelData cardModelData;

  @override
  Widget build(BuildContext context) {
    if (cardModelData.timeOfEvent != null)
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                'TIME',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1976D2),
                ),
              ),
              Text(cardModelData.timeOfEvent),
            ],
          ),
          VerticalDivider(
            color: Colors.deepOrange,
            width: 10.0,
            thickness: 20.0,
            endIndent: 0.1,
            indent: 0.1,
          ),
          VenueName(cardModelData: cardModelData),
        ],
      );
    else
      return SizedBox(
        height: 0,
        width: 0,
      );
  }
}

class VenueName extends StatelessWidget {
  const VenueName({
    Key key,
    @required this.cardModelData,
  }) : super(key: key);

  final CardModelData cardModelData;

  @override
  Widget build(BuildContext context) {
    if (cardModelData.venueForEvent != null)
      return Column(
        children: <Widget>[
          Text(
            'VENUE',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1976D2),
            ),
          ),
          Text(cardModelData.venueForEvent),
        ],
      );
    else
      return SizedBox(
        height: 0,
        width: 0,
      );
  }
}
