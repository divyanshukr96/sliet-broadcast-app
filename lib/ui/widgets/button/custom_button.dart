import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final Widget _child;

  const CustomIconButton({
    Key key,
    @required Widget child,
  })  : _child = child,
        assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      width: 36,
      child: ClipOval(
        child: Material(
          child: _child,
        ),
      ),
    );
  }
}
