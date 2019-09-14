import 'package:flutter/material.dart';

class NoticeCard extends StatefulWidget {
  @override
  _NoticeCardState createState() => _NoticeCardState();
}

class _NoticeCardState extends State<NoticeCard> {
  int numberOfLines = 2;

  var iconForText =  Icon(
    Icons.keyboard_arrow_down,
  );

  var imageForCard = null;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                              'Department of cse',
                            style: TextStyle(
                              fontWeight:FontWeight.bold,
                            ),
                          ),
                          Text('one day workshop'),
                        ],
                      ),
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text('13:22'),
                        Text('21 august 2018'),
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
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
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
                        Text('4:30pm'),
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
                        Text('MINI AUDI'),
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
