import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:sliet_broadcast/login.dart';
import './components/noticeCard.dart';
import './style/theme.dart' as Theme;

import './components/drawerItem.dart';
import './publicFeed.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return
      MaterialApp(
        debugShowCheckedModeBanner: false,
       home:Scaffold(
         resizeToAvoidBottomPadding: false,
         appBar: AppBar(),
         body: PublicFeed(),

         drawer: Drawer(
           // Add a ListView to the drawer. This ensures the user can scroll
           // through the options in the drawer if there isn't enough vertical
           // space to fit everything.
           child: ListView(
             // Important: Remove any padding from the ListView.
             padding: EdgeInsets.zero,
             children: <Widget>[
               DrawerHeader(
                 child: Text('SLIET BROADCAST'),
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
               ),
               ListTile(
                 title: Row(
                   mainAxisAlignment:MainAxisAlignment.start,
                   children: <Widget>[
                     prefix0.Text('Login',
                     style: TextStyle(),),
                   ],
                 ),
                 leading: Icon(Icons.person_outline),
                 onTap: () {
                   // Update the state of the app
                   // ...
                   // Then close the drawer
                   Navigator.pop(context);
                 },
               ),
               DrawerItem('click for hello',Icon(Icons.unfold_more),context,testFunction).getItem(),
                //Divider(thickness: 3.0,),
             ],
           ),
         ),
       ),
      );

  }

  void testFunction(){
    print('hello ');
  }
}