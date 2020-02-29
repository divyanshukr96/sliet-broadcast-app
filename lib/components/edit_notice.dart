import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sliet_broadcast/components/models/notice.dart';
import 'package:sliet_broadcast/components/notice_form.dart';
import 'package:sliet_broadcast/utils/network_utils.dart';
import 'package:sliet_broadcast/style/theme.dart' as Theme;

class EditNotice extends StatefulWidget {
  const EditNotice({
    Key key,
    @required this.notice,
  }) : super(key: key);

  final Notice notice;

  @override
  _EditNoticeState createState() => _EditNoticeState();
}

class _EditNoticeState extends State<EditNotice>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffold = new GlobalKey<ScaffoldState>();
  NetworkUtils networkUtils = new NetworkUtils();
  AnimationController _animationController;
  Dio dio = new Dio();
  String noticeId;
  ProgressDialog pr;

  List networkImages;
  List<Asset> images = List<Asset>();

  bool loading = false;

  int selectedRadio;
  bool _isEvent = true;
  bool _visible = true;
  bool _allDepartment = true;

  Set<String> selectedDepartment = Set<String>();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  TextEditingController _titleController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();
  TextEditingController _venueController = new TextEditingController();

  _submitNewNotice() async {
    Response response;
    final form = _formKey.currentState;

    // TODO optimise this
    List<String> _department = new List<String>();
    try {
      if (selectedDepartment != null && !_allDepartment) {
        setState(() {
          _department = selectedDepartment.toList();
        });
      }
    } catch (e) {
      print('edit_notice _submitNotice _departmentSelect onCatch Error $e');
    }

    if (_descriptionController.text == "" &&
        (files.length == 0 &&
            (networkImages == null || networkImages.length == 0))) {
//      _formSubmitting();
      return _scaffold.currentState.showSnackBar(SnackBar(
        content: Text(
          'Notice Description / Image field is required!',
          style: TextStyle(color: Colors.white70),
        ),
        backgroundColor: Colors.deepOrange,
        duration: Duration(seconds: 2),
      ));
    }

    if (_titleController.text == "") {
//      _formSubmitting();
      return _scaffold.currentState.showSnackBar(SnackBar(
        content: Text(
          'Notice title field is required!',
          style: TextStyle(color: Colors.white70),
        ),
        backgroundColor: Colors.deepOrange,
        duration: Duration(seconds: 2),
      ));
    }

    if (_department.length == 0 && !_allDepartment) {
//      _formSubmitting();
      return _scaffold.currentState.showSnackBar(SnackBar(
        content: Text(
          'Department field is required.',
          style: TextStyle(color: Colors.white70),
        ),
        backgroundColor: Colors.deepOrange,
        duration: Duration(seconds: 2),
      ));
    }

    if (form.validate()) {
      pr.style(message: 'Updating Notice...');
      pr.show();
      try {
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

        response = await dio.patch(
            NetworkUtils.productionHost + "/api/notice/$noticeId/",
            data: formData);

        if (response.statusCode == 200) {
          pr.hide().then((isHidden) {
            _backAction();
          });
        }
      } on DioError catch (e) {
        print('edit_notice _submitNotice onDioError Erorr $e');
      }
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3100),
    );

    _initNoticeData();
    _setNetwork();

    super.initState();
  }

  _initNoticeData() {
    final notice = widget.notice;
    noticeId = notice.id;
    _titleController.text = notice.titleOfEvent;
    _descriptionController.text = notice.aboutEvent;

    _isEvent = notice.isEvent;
    _visible = notice.visible;
    _allDepartment = notice.allDepartment;
    _venueController.text = notice.venueForEvent;
    _timeController.text = notice.timeOfEvent;

    _dateController.text = notice.dateOfEvent;

    selectedRadio = notice.public ? 1 : 0;

    networkImages = notice.imageList;
    try {
      notice.departments.forEach((e) {
        selectedDepartment.add(e);
      });
    } catch (e) {
      print('edit_notice _initNoticeData onCatch Error $e');
    }
  }

  void _setNetwork() async {
    String token = await networkUtils.getToken();
    dio.options.headers['Authorization'] = "Token " + token;
    dio.options.headers['content-type'] = "application/x-www-form-urlencoded";
    dio.options.headers['Accept'] = "application/json";
  }

  Future<dynamic> _deleteNetworkImage(index) async {
    Response response;
    try {
      String imageId = networkImages[index]['id'];
      response = await dio.delete(
        NetworkUtils.host + "/api/notice/$noticeId/image/$imageId",
      );
      if (response.statusCode == 204) {
        networkImages.removeAt(index);
        setState(() {
          networkImages = networkImages;
        });
      }
    } on DioError catch (error) {
      print('edit_notice _deleteNetworkImage onCatch Error $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    return Scaffold(
      key: _scaffold,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) => Container(
//      height: MediaQuery.of(context).size.height * .2,
          padding: EdgeInsets.all(8.0),
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
          child: SingleChildScrollView(
            child: SafeArea(
              child: Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text(
                              'Edit Notice',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          height: 24.0,
                          color: Colors.black,
                        ),
                        TitleInput(controller: _titleController),
                        DescriptionInput(controller: _descriptionController),
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
                                      child:
                                          Icon(Icons.help_outline, size: 20.0),
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
                          edit: true,
                          value: selectedDepartment,
                          allDepartment: _allDepartment,
                          selectedDepartment: (departments) {
                            setState(() {
                              selectedDepartment = departments;
                            });
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: NetworkImagesView(
                            images: networkImages ?? [],
                            delete: (index) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      "Warning !",
                                      style: TextStyle(color: Colors.orange),
                                    ),
                                    content: Text(
                                      "Are you sure want to delete this image?",
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: new Text("No"),
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      FlatButton(
                                        child: new Text("Yes"),
                                        onPressed: () async {
                                          await _deleteNetworkImage(index);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
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
                        RaisedButton(
                          textColor: Colors.white,
                          color: Colors.lightBlueAccent,
                          child: Text("Add images"),
                          onPressed: _loadAssets,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: RaisedButton(
                            highlightColor: Colors.transparent,
                            splashColor: Theme.Colors.loginGradientEnd,
                            textColor: Colors.white,
                            color: loading
                                ? Colors.white12
                                : Colors.lightBlueAccent,
                            child: Text("Update Notice"),
                            onPressed: loading ? () {} : _submitNewNotice,
                          ),
                        ),
                        FlatButton(
                          splashColor: Colors.lightBlue,
                          onPressed: _backAction,
                          child: Text(
                            "Back",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 18.0,
                              fontFamily: "WorkSansMedium",
                            ),
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
      print('edit_notice _loadAssets onExceptionCatch Error $e');
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

  void _backAction() {
    Navigator.pop(context);
  }
}
