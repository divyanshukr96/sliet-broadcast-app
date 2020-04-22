import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:sliet_broadcast/core/models/notice_list.dart';
import 'package:sliet_broadcast/ui/widgets/notice_form.dart';
import 'package:sliet_broadcast/core/constant.dart';
import 'package:sliet_broadcast/core/viewmodels/views/notice_create_model.dart';
import 'package:sliet_broadcast/style/theme.dart' as Theme;

class EditNotice extends StatefulWidget {
  final NoticeCreateModel model;
  final Notice notice;

  const EditNotice({
    Key key,
    @required this.notice,
    @required this.model,
  }) : super(key: key);

  @override
  _EditNoticeState createState() => _EditNoticeState();
}

class _EditNoticeState extends State<EditNotice>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  AnimationController _animationController;
  Dio dio = new Dio();

  List<String> _department = new List<String>();
  Set<String> selectedDepartment = Set<String>();

  Map<String, dynamic> _fieldError = Map();

  List<ImagesList> networkImages;
  List<Asset> images = List<Asset>();

  int selectedRadio;
  bool _isEvent = true;
  bool _visible = true;
  bool _allDepartment = true;

  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  TextEditingController _titleController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();
  TextEditingController _venueController = new TextEditingController();

  Future _submitNewNotice() async {
    FormData formData = new FormData.from({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'is_event': _isEvent,
      'venue': _venueController.text,
      'date': _dateController.text.isNotEmpty
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

    try {
      await widget.model.patchNotice(widget.notice, data: formData);
      _backAction(context);
    } on DioError catch (e) {
      if (e.response != null && e.response.data != null) {
        _fieldError.addAll(e.response.data);
        throw e;
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Something went wrong! try again'),
        ));
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3100),
    );

    _initNoticeData();

    super.initState();
  }

  _initNoticeData() {
    final notice = widget.notice;
    _titleController.text = notice.title;
    _descriptionController.text = notice.description;

    _isEvent = notice.isEvent;
    _visible = notice.visible;
    _allDepartment = notice.allDepartment;
    _venueController.text = notice.venue;
    _timeController.text = notice.time;

    _dateController.text = notice.date;

    selectedRadio = notice.publicNotice ? 1 : 0;

    networkImages = notice.imagesList;
    try {
      notice.department.forEach((e) {
        selectedDepartment.add(e);
      });
    } catch (e) {
      print('edit_notice _initNoticeData onCatch Error $e');
    }
  }

  Future<dynamic> _deleteNetworkImage(index) async {
    try {
      String imageId = networkImages[index].id;
      await widget.model.deleteImage(
        widget.notice.id,
        imageId,
      );
      networkImages.removeAt(index);
      setState(() {
        networkImages = networkImages;
      });
    } on DioError catch (error) {
      print('edit_notice _deleteNetworkImage onCatch Error $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) => Container(
//      height: MediaQuery.of(context).size.height * .2,
          padding: EdgeInsets.all(4.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(gradient: LoginLinearGradient()),
          child: SingleChildScrollView(
            child: SafeArea(
              child: Card(
                elevation: 2.0,
                color: Colors.white,
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
                              'Viewer : ',
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
                        Builder(builder: (context) {
                          if (selectedRadio == 0) return SizedBox(height: 0.0);
                          return Wrap(
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
                          );
                        }),
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
                            setState(() => _allDepartment = value);
                          },
                        ),
                        DepartmentSelection(
                          edit: true,
                          value: selectedDepartment,
                          allDepartment: _allDepartment,
                          departments: widget.model.departments,
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
                            delete: (index) async {
                              await _deleteNetworkImage(index);
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
                            color: widget.model.busy
                                ? Colors.green
                                : Colors.lightBlueAccent,

                            child: Text(widget.model.percentage > 0
                                ? 'Updating notice ${widget.model.percentage}%'
                                : "Update Notice"),
//                            child: Text("Update Notice"),
//                            onPressed: loading ? () {} : _submitNewNotice,

                            onPressed: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              if (widget.model.busy) return;
                              widget.model.setBusy();
                              if (await _validateFields()) {
                                try {
                                  await _submitNewNotice();
                                } catch (e) {
                                  await _showErrorMessage(context);
                                }
                              } else {
                                await _showErrorMessage(context);
                              }
                              widget.model.setBusy(value: false);
                              _fieldError.clear();
                            },
                          ),
                        ),
                        FlatButton(
                          splashColor: Colors.lightBlue,
                          onPressed: () => _backAction(context),
                          child: Text(
                            "Back",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 16.0,
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

  Future<bool> _validateFields() async {
    if (selectedDepartment != null && !_allDepartment) {
      setState(() {
        _department = selectedDepartment.toList();
      });
    }

    if (_titleController.text.isEmpty) {
      _fieldError.addAll({'title': 'Notice title field is required.'});
    }

    if (_descriptionController.text.isEmpty &&
        (files.length == 0 &&
            (networkImages == null || networkImages.length == 0))) {
      _fieldError.addAll({
        'description': 'Notice Description / Images is required !',
      });
    }

    if (_department.length == 0 && !_allDepartment) {
      _fieldError.addAll({
        'department': 'Preferred Department is not selected.',
      });
    }
    return _formKey.currentState.validate() && _fieldError.isEmpty;
  }

  Future _showErrorMessage(BuildContext context) async {
    Color _color;
    List<Widget> _child = List<Widget>();
    if (_fieldError.isNotEmpty) {
      _color = Colors.redAccent;
      _fieldError.forEach((label, value) {
        _child.add(Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(
            _getValue(value) + label.toString(), // TODO
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ));
      });
    } else {}

    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(color: _color),
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: Wrap(
            children: _child,
          ),
        );
      },
    );
  }

  String _getValue(value) {
    if (value.runtimeType != String) {
      return value[0];
    }
    return value;
  }

  void _backAction(context) {
    Navigator.pop(context, widget.model.notice);
  }
}
