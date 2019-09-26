import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';

import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:sliet_broadcast/style/theme.dart' as Theme;

class CreateNoticeTest extends StatefulWidget {
  @override
  _CreateNoticeTestState createState() => _CreateNoticeTestState();
}

class _CreateNoticeTestState extends State<CreateNoticeTest> {
  List<Asset> images = List<Asset>();

  String time = "";
  final format = DateFormat("yyyy-MM-dd");
  final controllerDate = TextEditingController();
  final controllerTime = TextEditingController();

  var selectedDate = DateTime.now();
  int selectedRadio;

  List _department = ["All", "CSE", "MECH", "ECE", "EIE"];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentCity;

  void _setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedRadio = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          // Where the linear gradient begins and ends
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Theme.Colors.loginGradientEnd,
            Theme.Colors.loginGradientStart,
          ],
        ),
      ),
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
          //margin: EdgeInsets.only(left:16,right:16),

          child: Card(
            elevation: 2.0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      maxLength: 150,
                      style: TextStyle(
                          fontFamily: "WorkSansSemiBold",
                          fontSize: 16.0,
                          color: Colors.black),
                      decoration: InputDecoration(
//                            border: InputBorder.none,
                        labelText: "Title",
                        hintStyle: TextStyle(
                            fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.lightBlueAccent, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 1.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      maxLength: 1000,
                      style: TextStyle(
                          fontFamily: "WorkSansSemiBold",
                          fontSize: 16.0,
                          color: Colors.black),
                      decoration: InputDecoration(
//                            border: InputBorder.none,
                        labelText: "Description",
                        hintStyle: TextStyle(
                            fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.lightBlueAccent, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 1.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      maxLength: 100,
                      style: TextStyle(
                          fontFamily: "WorkSansSemiBold",
                          fontSize: 16.0,
                          color: Colors.black),
                      decoration: InputDecoration(
//                            border: InputBorder.none,
                        labelText: "Venue",
                        hintStyle: TextStyle(
                            fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.lightBlueAccent, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 1.0),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: controllerTime,
                            onTap: () {
                              _selectTime(context);
                            },
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              labelText: "Time",
                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold",
                                  fontSize: 17.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.lightBlueAccent, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 1.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: controllerDate,
                            onTap: () {
                              _selectDate(context);
                            },
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              labelText: "Date",
                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold",
                                  fontSize: 17.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.lightBlueAccent, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 1.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio(
                        value: 1,
                        groupValue: selectedRadio,
                        activeColor: Colors.blue,
                        onChanged: (val) {
                          print("the value is $val");
                          _setSelectedRadio(val);
                        },
                      ),
                      Text('Public'),
                      Radio(
                        value: 0,
                        groupValue: selectedRadio,
                        activeColor: Colors.blue,
                        onChanged: (val) {
                          print("the value is $val");
                          _setSelectedRadio(val);
                        },
                      ),
                      Text('Faculty only'),
                    ],
                  ),
                  RaisedButton(
                    child: Text("Pick images"),
                    onPressed: _loadAssets,
                  ),
                  Expanded(
                    flex: 2,
                    child: buildGridView(),
                  ),
                  Text("helloo")
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loadAssets() async {
    List<Asset> resultList = List<Asset>();

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );

      for (var r in resultList) {
        var t = await r.filePath;
        print(t);
      }
    } on Exception catch (e) {
      e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
//      _error = error;
    });
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 4,
      crossAxisSpacing: 4,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 100,
          height: 100,
        );
      }),
    );
  }

  void handleGesture(BuildContext context) {
    if (Platform.isAndroid) {
      print('android');
    }
    if (Platform.isIOS) {
      print('ios');
    }
  }

  //Sets date in the field
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        //String date = selectedDate.toString();
        print(selectedDate.toString());
        var date = DateFormat("dd-MM-yyyy").format(picked);
        controllerDate.text = date.toString();
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final now = DateTime.now();

    final TimeOfDay picked = await showTimePicker(
      initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
      context: context,
    );

    if (picked != null)
      setState(() {
        var time = picked.hour.toString() + ":" + picked.minute.toString();
        print(picked.hour);
        print(picked.minute);

        controllerTime.text = time;
      });
  }
}
