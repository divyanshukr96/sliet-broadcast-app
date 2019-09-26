import 'package:flutter/material.dart';

class MultiSelectDialogItem<V> {
  const MultiSelectDialogItem(this.value, this.label);

  final V value;
  final String label;
}

class MultiSelectDialog<V> extends StatefulWidget {
  MultiSelectDialog(
      {Key key, this.items, this.initialSelectedValues, this.values})
      : super(key: key);

  final List<MultiSelectDialogItem<V>> items;
  final Set<V> initialSelectedValues;
  final Set<V> values;

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState<V>();
}

class _MultiSelectDialogState<V> extends State<MultiSelectDialog<V>> {
  final _selectedValues = Set<V>();

  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
//      _selectedValues.addAll(widget.initialSelectedValues);
    }
    if (widget.values != null) _selectedValues.addAll(widget.values);
  }

//  _build(MultiSelectDialogItem<V> item) {
//    if (item.value != "ALL") {
//      _selectedValues.add(item.value);
//      print(_selectedValues);
//      return item.value;
//    }
//  }

  void _onItemCheckedChange(V itemValue, bool checked) {
    setState(() {
      if (checked) {
        if (itemValue == "ALL") {
          widget.items.forEach((data) {
            _selectedValues.add(data.value);
          });
        } else
          _selectedValues.add(itemValue);
      } else {
        if (itemValue == "ALL")
          widget.items.forEach((data) {
            _selectedValues.remove(data.value);
          });
        else {
          _selectedValues.remove(itemValue);
          if (_selectedValues.contains("ALL")) _selectedValues.remove("ALL");
        }
      }
    });
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSubmitTap() {
    Navigator.pop(context, _selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select target departments'),
      contentPadding: EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          child: ListBody(
            children: widget.items.map(_buildItem).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: _onCancelTap,
        ),
        FlatButton(
          child: Text('SELECT'),
          onPressed: _onSubmitTap,
        )
      ],
    );
  }

  Widget _buildItem(MultiSelectDialogItem<V> item) {
    final checked = _selectedValues.contains(item.value);
    return CheckboxListTile(
      dense: false,
      value: checked,
      title: Text(item.label),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(item.value, checked),
    );
  }
}
