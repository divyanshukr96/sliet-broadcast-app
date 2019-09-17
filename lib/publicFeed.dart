import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sliet_broadcast/style/theme.dart' as Theme;
import './components/models/cardModel.dart';
import './components/noticeCard.dart';


class PublicFeed extends StatefulWidget {
  @override
  _PublicFeedState createState() => _PublicFeedState();
}

class _PublicFeedState extends State<PublicFeed> {

  Future<List<CardModelData>> _getNotices() async{

    var data = await http.get("http://www.json-generator.com/api/json/get/bONszPwHoy?indent=2");
    var jsonData = json.decode(data.body);
    //print(jsonData);

    List<CardModelData> cardsList = [];

    for(var i in jsonData){

      CardModelData card = CardModelData(i['nameOfUploader'],
      i['titleOfEvent'],i['dateOfNoticeUpload'],i['timeOfNoticeUpload'],
      i['imageUrlNotice'],i['timeOfEvent'],i['dateOfEvent'],i['venueForEvent'],
      i['aboutEvent']);

      cardsList.add(card);

  }
    print(cardsList.length);

    return cardsList;
}

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width:  MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.Colors.loginGradientEnd,
              Theme.Colors.loginGradientStart,
            ],

          )
      ),
      child: Center(
        child: FutureBuilder(
          future: _getNotices(), // a previously-obtained Future<String> or null
          builder: (BuildContext context, AsyncSnapshot snapshot) {

           /* switch (snapshot.connectionState) {
              case ConnectionState.none:
                print('connectionstate.none was executed');
                return Text('Press button to start.');
              case ConnectionState.active:print('connection was active');
                                        break;
              case ConnectionState.waiting:
                print('we were waiting');
                return CircularProgressIndicator();
              case ConnectionState.done:
                if (snapshot.hasError)
                  return Text('Error: ${snapshot.error}');
                print('i was here');
                return Text('Result: ${snapshot.data}');
            }
            return null; // unreachable*/
           if(snapshot.data == null){
             return CircularProgressIndicator();
           }
           else{
             return ListView.builder(
               itemCount: snapshot.data.length ,
                 itemBuilder: (BuildContext context,int index){
                 print(snapshot.data[index]);
                 return NoticeCard(snapshot.data[index]);
                 }
               );
           }

          },
        ),
      ),

    );
  }

}
