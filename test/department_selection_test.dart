import 'package:flutter/material.dart';
import 'package:sliet_broadcast/components/department_selection.dart';
import 'package:sliet_broadcast/utils/network_utils.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  var selected;
  var departments = new List();

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
          values: selected,
        );
      },
    );
    setState(() {
      selected = selectedValues;
    });
    print(selectedValues);
  }

  @override
  void initState() {
    _fetchDepartment();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton.icon(
              textColor: Colors.white,
              color: Colors.lightBlueAccent,
              label: Text("Select images"),
              onPressed: () {
                _showMultiSelect(context);
              },
              icon: Icon(Icons.cloud_upload),
            ),
          ],
        ),
      ),
    );
  }
}
