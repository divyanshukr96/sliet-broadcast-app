import 'package:flutter/material.dart';

class DrawerItem{

  String text;
  Icon icon;
  var listTile;


  DrawerItem(String text,Icon icon,var context,var functionAddress){
    this.text = text;
    this.icon = icon;

    this.listTile = ListTile(
      title: Row(
        mainAxisAlignment:MainAxisAlignment.start,
        children: <Widget>[
          Text(text),
        ],
      ),
      leading: icon,
      onTap:functionAddress,
    );


  }

  ListTile getItem(){
    return this.listTile;
  }


}