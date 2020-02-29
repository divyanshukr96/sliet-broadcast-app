import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sliet_broadcast/components/notice_form.dart';
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
  bool _visible = true;
  bool _allDepartment = true;
  var percentage;

  // department selection variable
  var selectedDepartment;

  String time = "";

  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  TextEditingController _titleController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();
  TextEditingController _venueController = new TextEditingController();

  int selectedRadio;

  void _formSubmitting() {
    setState(() {
      loading = !loading;
    });
  }

  @override
  void initState() {
    selectedRadio = 1;
    networkUtils.isAuthenticated().then((onValue) {
      setState(() {
        authenticated = onValue;
      });
    });
    super.initState();
  }

  _submitNewNotice() async {
    _formSubmitting();
    Response response;
    Dio dio = new Dio();

    String token = await networkUtils.getToken();

    final form = _formKey.currentState;

    // TODO optimise this
    List<String> _department = new List<String>();
    if (selectedDepartment != null && !_allDepartment) {
      setState(() {
        _department = selectedDepartment.toList();
      });
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
    if (_department.length == 0 && !_allDepartment) {
      _formSubmitting();
      return Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          'Department is not selected.',
          style: TextStyle(color: Colors.white70),
        ),
        backgroundColor: Colors.deepOrange,
        duration: Duration(seconds: 2),
      ));
    }
    if (form.validate()) {
      FocusScope.of(context).requestFocus(new FocusNode());
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
        'visible': _visible,
        'all_department': _allDepartment,
        'files': files,
      });

      if (!_allDepartment) formData.add('department', _department.toList());

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
            _visible = true;
            _allDepartment = true;
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
        await pr.hide();
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

    return SingleChildScrollView(
      child: Container(
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
                      TitleInput(controller: _titleController),
                      DescriptionInput(controller: _descriptionController),
                      CheckboxListTile(
                        dense: true,
                        title: Text(
                          'Add event venue with date & time',
                          style: TextStyle(fontSize: 15.0),
                        ),
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
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: 18.0,
                          ),
                          Text(
                            'Choose viewer : ',
                            textAlign: TextAlign.start,
                          ),
                          Radio(
                            value: 1,
                            groupValue: selectedRadio,
                            activeColor: Colors.blue,
                            onChanged: (val) {
                              setState(() {
                                selectedRadio = val;
                              });
                            },
                          ),
                          Text('Public'),
                          Radio(
                            value: 0,
                            groupValue: selectedRadio,
                            activeColor: Colors.blue,
                            onChanged: (val) {
                              setState(() {
                                _visible = false;
                                selectedRadio = val;
                              });
                            },
                          ),
                          Text('Faculty only'),
                        ],
                      ),
                      Divider(),
                      selectedRadio == 0
                          ? SizedBox(height: 0.0)
                          : Wrap(
                              children: <Widget>[
                                CheckboxListTile(
                                  dense: true,
                                  title: Text(
                                    'Make notice visible to all users.',
                                    style: TextStyle(fontSize: 15.0),
                                  ),
                                  secondary: GestureDetector(
                                    child: Icon(Icons.help_outline, size: 20.0),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: Text(
                                              'This notice is visible to all users whether it is from SLIET or not.',
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  value: _visible,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  onChanged: (bool value) {
                                    setState(() => _visible = !_visible);
                                  },
                                ),
                                Divider(),
                              ],
                            ),
                      CheckboxListTile(
                        dense: true,
                        title: Text(
                          'Notice for all Departments',
                          style: TextStyle(fontSize: 15.0),
                        ),
                        secondary: GestureDetector(
                          child: Icon(Icons.help_outline, size: 20.0),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Text(
                                    'Publish this notice for all departments student/faculty.',
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        value: _allDepartment,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (bool value) {
                          setState(() => _allDepartment = !_allDepartment);
                        },
                      ),
                      DepartmentSelection(
                        value: selectedDepartment,
                        allDepartment: _allDepartment,
                        selectedDepartment: (departments) {
                          setState(() {
                            selectedDepartment = departments;
                          });
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
                        remove: (index) {
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
      ),
    );
  }

  Widget buildVenueDateTime(BuildContext context) {
    if (!_isEvent) return SizedBox(height: 0.0);
    return Column(
      children: <Widget>[
        VenueInput(controller: _venueController),
        DateAndTime(time: _timeController, date: _dateController),
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
    } on Exception catch (e) {
      print('createNotice loadAssets Error $e');
    }

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
}
