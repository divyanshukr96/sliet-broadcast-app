import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:sliet_broadcast/components/department_selection.dart';
import 'package:sliet_broadcast/utils/network_utils.dart';

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
              style: TextStyle(
                  fontFamily: "WorkSansSemiBold",
                  fontSize: 16.0,
                  color: Colors.black),
              decoration: InputDecoration(
                labelText: "Time",
                hintStyle:
                    TextStyle(fontFamily: "WorkSansSemiBold", fontSize: 17.0),
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
              style: TextStyle(
                  fontFamily: "WorkSansSemiBold",
                  fontSize: 16.0,
                  color: Colors.black),
              decoration: InputDecoration(
                labelText: "Date",
                hintStyle:
                    TextStyle(fontFamily: "WorkSansSemiBold", fontSize: 17.0),
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

class DepartmentSelection extends StatefulWidget {
  const DepartmentSelection({
    Key key,
    @required this.selectedDepartment,
    @required this.value,
    bool edit,
  })  : _edit = edit ?? false,
        super(key: key);

  final bool _edit;
  final value;
  final VoidCallback selectedDepartment;

  @override
  _DepartmentSelectionState createState() => _DepartmentSelectionState();
}

class _DepartmentSelectionState extends State<DepartmentSelection> {
  var departments = new List();

  @override
  void initState() {
    _fetchDepartment();
    super.initState();
  }

  _fetchDepartment() async {
    try {
      var responseJson = await NetworkUtils.get("/api/public/department");
      if (responseJson != null)
        setState(() {
          departments = responseJson;
        });
    } catch (e) {
      print('Error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      textColor: Colors.white,
      color: Colors.lightBlueAccent,
      child: Text("Select Target Department"),
      onPressed: () {
        _showMultiSelect(context);
      },
    );
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
          values: widget.value,
        );
      },
    );
    if (widget._edit && selectedValues == null)
      widget.selectedDepartment(widget.value);
    else
      widget.selectedDepartment(selectedValues);
  }
}
