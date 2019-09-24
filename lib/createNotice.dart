import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:sliet_broadcast/components/department_selection.dart';
import 'package:sliet_broadcast/style/theme.dart' as Theme;
import 'package:sliet_broadcast/utils/auth_utils.dart';
import 'package:sliet_broadcast/utils/network_utils.dart';

class CreateNotice extends StatefulWidget {
  @override
  _CreateNoticeState createState() => _CreateNoticeState();
}

class _CreateNoticeState extends State<CreateNotice> {
  List<Asset> images = List<Asset>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  NetworkUtils networkUtils = new NetworkUtils();
  bool authenticated = false;

  // department selection variable
  var selectedDepartment;
  var departments = new List();

  String time = "";
  final format = DateFormat("yyyy-MM-dd");
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  TextEditingController _titleController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();
  TextEditingController _venueController = new TextEditingController();

  var selectedDate = DateTime.now();
  int selectedRadio;

  void _setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  @override
  void initState() {
    _fetchDepartment();
    super.initState();
    selectedRadio = 1;
    NetworkUtils.get("/api/public/department");
    networkUtils.isAuthenticated().then((onValue) {
      setState(() {
        authenticated = onValue;
      });
    });
  }

  _fetchDepartment() async {
    var responseJson = await NetworkUtils.get("/api/public/department");
    if (responseJson.toString() != null)
      setState(() {
        setState(() {
          departments = responseJson;
        });
      });
  }

  void _showMultiSelect(BuildContext context) async {
    final items = <MultiSelectDialogItem<String>>[
      MultiSelectDialogItem('ALL', 'ALL'),
    ];
    var data = departments.map(
      (dept) => items.add(MultiSelectDialogItem(dept['id'], dept['name'])),
    );
    print(data);
    final selectedValues = await showDialog<Set<String>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
          initialSelectedValues: null,
          values: selectedDepartment,
        );
      },
    );
    setState(() {
      selectedDepartment = selectedValues;
    });
  }

  _submitNewNotice() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      var responseJson = await NetworkUtils.post('/api/submit', {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'venue': _venueController.text,
        'date': _dateController.text,
        'time': _titleController.text,
        'public_notice': selectedRadio,
        'department': selectedDepartment,
        'images': [],
      });

//      if (responseJson == null) {
//        NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong!');
//      } else if (responseJson == 'NetworkError') {
//        NetworkUtils.showSnackBar(_scaffoldKey, null);
//      } else if (responseJson['errors'] != null) {
//        NetworkUtils.showSnackBar(_scaffoldKey, 'Invalid Email/Password');
//      } else {
//        AuthUtils.insertDetails(_sharedPreferences, responseJson);
//        Navigator.of(_scaffoldKey.currentContext).pop();
//        Navigator.of(_scaffoldKey.currentContext).push(
//          MaterialPageRoute(
//            builder: (BuildContext context) => HomePage(),
//          ),
//        );
//      }
//      _hideLoading();
    } else {
      setState(() {
//        _isLoading = false;
//        _emailError;
//        _passwordError;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
//      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
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
          margin: EdgeInsets.all(16.0),
          child: Card(
            elevation: 2.0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text(
                          'Add new Notice',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Divider(),
                    TitleInput(titleController: _titleController),
                    DescriptionInput(
                        descriptionController: _descriptionController),
                    VenueInput(venueController: _venueController),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _timeController,
                              onTap: () {
                                _selectTime(context);
                              },
                              readOnly: true,
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
                                      color: Colors.lightBlueAccent,
                                      width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 1.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _dateController,
                              onTap: () {
                                _selectDate(context);
                              },
                              readOnly: true,
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
                                      color: Colors.lightBlueAccent,
                                      width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 1.0),
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
                      textColor: Colors.white,
                      color: Colors.lightBlueAccent,
                      child: Text("Select Target Department"),
                      onPressed: () {
                        _showMultiSelect(context);
                      },
                    ),
                    RaisedButton.icon(
                      textColor: Colors.white,
                      color: Colors.lightBlueAccent,
                      label: Text("Select images"),
                      onPressed: _loadAssets,
                      icon: Icon(Icons.cloud_upload),
                    ),
                    ImagesView(images: images),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: RaisedButton.icon(
                        highlightColor: Colors.transparent,
                        splashColor: Theme.Colors.loginGradientEnd,
                        textColor: Colors.white,
                        color: Colors.lightBlueAccent,
                        label: Text("Submit"),
                        onPressed: _submitNewNotice,
                        icon: Icon(Icons.save),
                      ),
                    ),
                  ],
                ),
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
        maxImages: 10,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#40C4FF",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {}

    if (!mounted) return;

    setState(() {
      images = resultList;
    });
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
        _dateController.text = date.toString();
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
        _dateController.text = time;
      });
  }
}

class VenueInput extends StatelessWidget {
  const VenueInput({
    Key key,
    @required TextEditingController venueController,
  })  : _venueController = venueController,
        super(key: key);

  final TextEditingController _venueController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _venueController,
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
          hintStyle: TextStyle(fontFamily: "WorkSansSemiBold", fontSize: 17.0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1.0),
          ),
        ),
      ),
    );
  }
}

class DescriptionInput extends StatelessWidget {
  const DescriptionInput({
    Key key,
    @required TextEditingController descriptionController,
  })  : _descriptionController = descriptionController,
        super(key: key);

  final TextEditingController _descriptionController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _descriptionController,
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
          hintStyle: TextStyle(fontFamily: "WorkSansSemiBold", fontSize: 17.0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1.0),
          ),
        ),
      ),
    );
  }
}

class TitleInput extends StatelessWidget {
  const TitleInput({
    Key key,
    @required TextEditingController titleController,
  })  : _titleController = titleController,
        super(key: key);

  final TextEditingController _titleController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _titleController,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        maxLength: 150,
        style: TextStyle(
            fontFamily: "WorkSansSemiBold",
            fontSize: 16.0,
            color: Colors.black),
        decoration: InputDecoration(
          labelText: "Title",
          hintStyle: TextStyle(fontFamily: "WorkSansSemiBold", fontSize: 17.0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1.0),
          ),
        ),
      ),
    );
  }
}

class ImagesView extends StatelessWidget {
  const ImagesView({
    Key key,
    @required this.images,
  }) : super(key: key);

  final List<Asset> images;

  @override
  Widget build(BuildContext context) {
    double height = (images.length / 4).ceilToDouble() * 90.0;
    if (images.length <= 0) return SizedBox(height: 0.0);
    return Container(
      height: height,
      child: GridView.count(
        crossAxisCount: 4,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        children: List.generate(images.length, (index) {
          Asset asset = images[index];
          return AssetThumb(
            asset: asset,
            width: 100,
            height: 100,
          );
        }),
      ),
    );
  }
}
