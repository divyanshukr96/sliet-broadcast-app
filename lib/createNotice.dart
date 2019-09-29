import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sliet_broadcast/components/department_selection.dart';
import 'package:sliet_broadcast/style/theme.dart' as Theme;
import 'package:sliet_broadcast/utils/network_utils.dart';

class CreateNotice extends StatefulWidget {
  @override
  _CreateNoticeState createState() => _CreateNoticeState();
}

class _CreateNoticeState extends State<CreateNotice> {
  List<Asset> images = List<Asset>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  NetworkUtils networkUtils = new NetworkUtils();
  ProgressDialog pr;
  bool authenticated = false;
  bool loading = false;
  bool _isEvent = false;
  var percentage;

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

  void _formSubmitting() {
    setState(() {
      loading = !loading;
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
    print(data); // required this print necessary
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
    _formSubmitting();
    Response response;
    Dio dio = new Dio();

    String token = await networkUtils.getToken();

    final form = _formKey.currentState;
    List<String> _department = new List<String>();
    if (selectedDepartment != null) {
      setState(() {
        _department = selectedDepartment.toList();
      });
    }
    _department.removeWhere((value) => value == "ALL");

    if (_titleController.text == "") {
      _formSubmitting();
      return Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          'Notice title field is required!',
          style: TextStyle(color: Colors.white70),
        ),
        backgroundColor: Colors.deepOrange,
        duration: Duration(seconds: 2),
      ));
    }

    if (_descriptionController.text == "" && files.length == 0) {
      _formSubmitting();
      return Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          'Notice Description / Image field is required!',
          style: TextStyle(color: Colors.white70),
        ),
        backgroundColor: Colors.deepOrange,
        duration: Duration(seconds: 2),
      ));
    }
    if (_department.length == 0) {
      _formSubmitting();
      return Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          'Department field is required.',
          style: TextStyle(color: Colors.white70),
        ),
        backgroundColor: Colors.deepOrange,
        duration: Duration(seconds: 2),
      ));
    }
    if (form.validate()) {
      FormData formData = new FormData.from({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'is_event': _isEvent,
        'venue': _venueController.text,
        'date': _dateController.text != ''
            ? DateFormat("yyyy-MM-dd")
                .format(DateFormat("dd-MM-yyyy").parse(_dateController.text))
                .toString()
            : null,
        'time': _timeController.text,
        'public_notice': selectedRadio,
        'department': _department.toList(),
        'files': files,
      });

      pr.style(message: 'Uploading Notice...');
      pr.show();
      try {
        dio.options.headers['Authorization'] = "Token " + token;
        dio.options.headers['content-type'] =
            "application/x-www-form-urlencoded";
        dio.options.headers['Accept'] = "application/json";
        response = await dio.post(
          NetworkUtils.productionHost + "/api/notice/",
          data: formData,
          // upload progress can be updated here
          onSendProgress: (int sent, int total) {
            var per = percentage = ((sent / total) * 100).toInt();
//            pr.update(
////              message: 'Uploading Notice... $per %',
////            );
          },
        );

        if (response.statusCode == 201) {
          form.reset();
          setState(() {
            _titleController.clear();
            _descriptionController.clear();
            _venueController.clear();
            _dateController.clear();
            _timeController.clear();
            selectedRadio = 1;
            selectedDepartment = null;
            _isEvent = false;
          });
          _department.clear();
          files.clear();
          images.clear();
          pr.hide().then((isHidden) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
                'Notice successfully uploaded',
                style: TextStyle(color: Colors.white70, fontSize: 18.0),
              ),
              backgroundColor: Colors.green,
            ));
          });
        }
      } on DioError catch (e) {
        pr.hide();
        if (e.response != null) {
          if (e.response.data != null)
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
                'Title / Description or Image / Department field required!',
                style: TextStyle(color: Colors.white70),
              ),
              backgroundColor: Colors.deepOrange,
            ));
        } else {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Something went wrong!'),
          ));
        }
      }
      _formSubmitting();
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);

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
          margin: EdgeInsets.all(8.0),
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
                    CheckboxListTile(
                      dense: true,
                      title: Text('Add event venue with date & time'),
                      value: _isEvent,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (bool value) {
                        if (!_isEvent) {
                          _venueController.clear();
                          _dateController.clear();
                          _timeController.clear();
                        }
                        setState(() {
                          _isEvent = !_isEvent;
                        });
                      },
                    ),
                    buildVenueDateTime(context),
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
                    ImagesView(
                      images: images,
                      remove: (int index) {
                        images.removeAt(index);
                        setState(() {
                          images = images;
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: RaisedButton.icon(
                        highlightColor: Colors.transparent,
                        splashColor: Theme.Colors.loginGradientEnd,
                        textColor: Colors.white,
                        color:
                            loading ? Colors.white12 : Colors.lightBlueAccent,
                        label: Text("Submit"),
                        onPressed: loading ? () {} : _submitNewNotice,
                        icon: Icon(loading ? Icons.cached : Icons.save),
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

  Widget buildVenueDateTime(BuildContext context) {
    if (!_isEvent) return SizedBox(height: 0.0);
    return Column(
      children: <Widget>[
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
                        fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1.0),
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
                        fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1.0),
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
                _setSelectedRadio(val);
              },
            ),
            Text('Public'),
            Radio(
              value: 0,
              groupValue: selectedRadio,
              activeColor: Colors.blue,
              onChanged: (val) {
                _setSelectedRadio(val);
              },
            ),
            Text('Faculty only'),
          ],
        ),
      ],
    );
  }

  Future<void> _loadAssets() async {
    files.clear();
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

    int count = 0;
    for (var asset in resultList) {
      ByteData byteData = await asset.getByteData();
      if (byteData != null) {
        List<int> imageData = byteData.buffer.asUint8List();
        UploadFileInfo multipartImage =
            UploadFileInfo.fromBytes(imageData, asset.name);
        files['images_$count'] = multipartImage;
        count += 1;
      }
    }

    setState(() {
      images = resultList;
    });
  }

  var files = {};

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
      firstDate: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        var date = DateFormat("dd-MM-yyyy").format(picked);
        _dateController.text = date.toString();
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final now = DateTime.now();

    final TimeOfDay picked = await showTimePicker(
      initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
      context: context,
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
    );

    if (picked != null)
      setState(() {
        var time = picked.hour.toString() + ":" + picked.minute.toString();
        _timeController.text = time;
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

typedef VoidCallback = void Function(int);

class ImagesView extends StatelessWidget {
  const ImagesView({
    Key key,
    @required this.images,
    @required this.remove,
  }) : super(key: key);

  final List<Asset> images;
  final VoidCallback remove;

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
          return Stack(
            children: <Widget>[
              AssetThumb(
                asset: asset,
                width: 120,
                height: 120,
              ),
              Positioned(
                top: -11,
                right: -11,
                child: IconButton(
                  icon: Icon(Icons.close),
                  color: Colors.red,
                  onPressed: () {
                    remove(index);
                  },
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
