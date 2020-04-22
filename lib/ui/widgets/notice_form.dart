import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:sliet_broadcast/ui/widgets/department_selection.dart';
import 'package:sliet_broadcast/core/models/department.dart';
import 'package:sliet_broadcast/core/models/notice_list.dart';

class TitleInput extends StatelessWidget {
  const TitleInput({
    Key key,
    @required TextEditingController controller,
  })  : _controller = controller,
        super(key: key);

  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _controller,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        maxLength: 150,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          isDense: true,
          labelText: "Title",
          hintStyle: TextStyle(fontSize: 17.0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.redAccent, width: 1.0),
          ),
        ),
        validator: (value) {
          if (value.isEmpty) return 'Notice title field is required.';
          if (value.length < 5) return 'Title must be more than 5 charater.';
          return null;
        },
      ),
    );
  }
}

class DescriptionInput extends StatelessWidget {
  const DescriptionInput({
    Key key,
    @required TextEditingController controller,
  })  : _controller = controller,
        super(key: key);

  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _controller,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        maxLength: 1000,
        style: TextStyle(fontSize: 16.0, color: Colors.black),
        decoration: InputDecoration(
          isDense: true,
          labelText: "Description",
          hintStyle: TextStyle(fontSize: 17.0),
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

class VenueInput extends StatelessWidget {
  const VenueInput({
    Key key,
    @required TextEditingController controller,
  })  : _controller = controller,
        super(key: key);

  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _controller,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        maxLength: 100,
        style: TextStyle(fontSize: 16.0, color: Colors.black),
        decoration: InputDecoration(
          isDense: true,
          labelText: "Venue",
          hintStyle: TextStyle(fontSize: 17.0),
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

class DateAndTime extends StatelessWidget {
  const DateAndTime({
    Key key,
    @required TextEditingController time,
    @required TextEditingController date,
  })  : _time = time,
        _date = date,
        super(key: key);

  final TextEditingController _time;
  final TextEditingController _date;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _time,
              onTap: () {
                _selectTime(context);
              },
              readOnly: true,
              style: TextStyle(fontSize: 16.0, color: Colors.black),
              decoration: InputDecoration(
                isDense: true,
                labelText: "Time",
                hintStyle: TextStyle(fontSize: 17.0),
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
              controller: _date,
              onTap: () {
                _selectDate(context);
              },
              readOnly: true,
              style: TextStyle(fontSize: 16.0, color: Colors.black),
              decoration: InputDecoration(
                isDense: true,
                labelText: "Date",
                hintStyle: TextStyle(fontSize: 17.0),
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
    );
  }

  Future<Null> _selectTime(BuildContext context) async {
    final now = DateTime.now();
    TimeOfDay __initTime = TimeOfDay(hour: now.hour, minute: now.minute);
    if (_time.text != "") {
      final dd = _time.text.split(':');
      __initTime = TimeOfDay(hour: int.parse(dd[0]), minute: int.parse(dd[1]));
    }
    final TimeOfDay picked = await showTimePicker(
      initialTime: __initTime,
      context: context,
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
    );

    if (picked != null) {
      _time.text = picked.hour.toString() + ":" + picked.minute.toString();
    }
  }

  //Sets date in the field
  Future<Null> _selectDate(BuildContext context) async {
    var selectedDate = _date.text == ""
        ? DateTime.now()
        : DateFormat("dd-MM-yyyy").parse(_date.text);
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

    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      var dateRaw = DateFormat("dd-MM-yyyy").format(picked);
      _date.text = dateRaw.toString();
    }
  }

  void handleGesture(BuildContext context) {
    if (Platform.isAndroid) {
      print('android');
    }
    if (Platform.isIOS) {
      print('ios');
    }
  }
}

typedef VoidCallback = void Function(dynamic);
typedef VoidCallbackFuture = Future<void> Function(dynamic);

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

class NetworkImagesView extends StatelessWidget {
  const NetworkImagesView({
    Key key,
    @required this.images,
    @required this.delete,
  }) : super(key: key);

  final List<ImagesList> images;
  final VoidCallbackFuture delete;

  @override
  Widget build(BuildContext context) {
    double height = (images.length / 3).ceilToDouble() * 120.0;
    if (images.length <= 0) return SizedBox(height: 0.0);
    return Container(
      height: height,
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        children: List.generate(images.length, (index) {
          return Stack(
            children: <Widget>[
              Image.network(
                images[index].url,
                fit: BoxFit.cover,
                height: 120,
              ),
              Positioned(
                top: -8,
                right: -8,
                child: IconButton(
                  icon: Icon(Icons.close),
                  color: Colors.red,
                  onPressed: () async {
                    await showDialog(
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
                                await delete(index);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
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

class DepartmentSelection extends StatelessWidget {
  const DepartmentSelection({
    Key key,
    @required this.selectedDepartment,
    @required Set<String> value,
    bool allDepartment,
    bool edit,
    List<Department> departments,
  })  : _edit = edit ?? false,
        allDepartment = allDepartment ?? false,
        value = value,
        departments = departments,
        super(key: key);

  final bool allDepartment;
  final bool _edit;
  final Set<String> value;
  final List<Department> departments;
  final VoidCallback selectedDepartment;

  @override
  Widget build(BuildContext context) {
    int length = value.toList().length;
    if (allDepartment) return SizedBox(height: 0.0);
    return RaisedButton(
      textColor: Colors.white,
      color: Colors.lightBlueAccent,
      child: Text("Select Preferred Department ($length)"),
      onPressed: () {
        _showMultiSelect(context);
      },
    );
  }

  void _showMultiSelect(BuildContext context) async {
    final items = <MultiSelectDialogItem<String>>[];
    departments.forEach((dept) {
      items.add(MultiSelectDialogItem(dept.id, dept.name));
    });
//    var data = widget.departments.map(
//      (dept) => items.add(MultiSelectDialogItem(dept.id, dept.name)),
//    );
//    print(data); // required this print necessary
    final selectedValues = await showDialog<Set<String>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
          initialSelectedValues: null,
          values: value,
        );
      },
    );
    if (_edit && selectedValues == null)
      selectedDepartment(value);
    else
      selectedDepartment(selectedValues ?? Set<String>());
    FocusScope.of(context).requestFocus(new FocusNode());
  }
}
