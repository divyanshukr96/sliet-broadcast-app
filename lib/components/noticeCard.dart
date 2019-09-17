import 'package:flutter/material.dart';
import 'package:sliet_broadcast/components/models/cardModel.dart';

import './models/cardModel.dart';

class NoticeCard extends StatefulWidget {

  CardModelData cardModelData;

  NoticeCard(this.cardModelData);

  @override
  _NoticeCardState createState() => _NoticeCardState(cardModelData);
}

class _NoticeCardState extends State<NoticeCard> {

  CardModelData cardModelData;
  _NoticeCardState(this.cardModelData);

  int numberOfLines = 2;

  var iconForText =  Icon(
    Icons.keyboard_arrow_down,
  );

  var imageForCard = null;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top:8.0,left:16.0,right:16.0,bottom:8.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 25.0,
                      backgroundColor:
                          Colors.brown, //change this to backgroundImage
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            cardModelData.nameOfUploader,
                            style: TextStyle(
                              fontWeight:FontWeight.bold,
                            ),
                          ),
                          Text(cardModelData.titleOfEvent),
                        ],
                      ),
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(cardModelData.timeOfNoticeUpload),
                        Text(cardModelData.dateOfNoticeUpload),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0,right: 0,top: 8.0,bottom: 16.0),
                  child: imageForCard,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    cardModelData.aboutEvent,
                    overflow: TextOverflow.ellipsis,
                    maxLines: numberOfLines,
                  ),
                ),
                Row(
                  // mainAxisSize: MainAxisSize.max,
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
                    VerticalDivider(color: Colors.deepOrange,width: 10.0,thickness: 20.0,endIndent: 0.1,indent: 0.1,),
                    Column(
                      children: <Widget>[
                        Text(
                            'VENUE',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1976D2),
                        ),),
                        Text(cardModelData.venueForEvent),
                      ],
                    ),
                  ],
                ),
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
      ),
    );
  }

  void changeLines() {
    if (numberOfLines == 2) {
      numberOfLines = 1000;
      iconForText =  Icon(
        Icons.keyboard_arrow_up,
      );

      imageForCard = FadeInImage.assetNetwork(
        placeholder: 'assets/images/imageloading1.gif',
        image: 'https://picsum.photos/250?image=9',
        fit: BoxFit.cover,
      );

    } else {
      numberOfLines = 2;
      iconForText =  Icon(
        Icons.keyboard_arrow_down,
      );
      imageForCard = null;
    }
    setState(() {
      numberOfLines = numberOfLines;
    });
    print(numberOfLines);
  }
}
