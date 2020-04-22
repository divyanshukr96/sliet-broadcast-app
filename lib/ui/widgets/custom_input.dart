import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterFieldError extends StatelessWidget {
  const RegisterFieldError({
    Key key,
    @required this.error,
    @required this.name,
  }) : super(key: key);

  final Map<String, dynamic> error;
  final String name;

  @override
  Widget build(BuildContext context) {
    if (error == null || error.length == 0 || error[name] == null)
      return SizedBox(height: 0.0);
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(error[name].toString(), style: TextStyle(color: Colors.red)),
    );
  }
}

class InputTextForm extends StatelessWidget {
  const InputTextForm({
    Key key,
    @required TextEditingController controller,
    FocusNode focusNode,
    String label,
    String errorText,
    TextInputType keyboardType,
    int maxLength,
    FormFieldValidator<String> validator,
    List<TextInputFormatter> inputFormatters,
    GestureTapCallback onTap,
    bool readOnly = false,
    bool obscureText = false,
    bool enableInteractiveSelection = true,
    EdgeInsetsGeometry contentPadding,
    ValueChanged<String> onChanged,
  })  : _controller = controller,
        _focusNode = focusNode,
        _label = label,
        _errorText = errorText,
        _keyboardType = keyboardType,
        _maxLength = maxLength,
        _validator = validator,
        _inputFormatters = inputFormatters,
        _onTap = onTap,
        _readOnly = readOnly,
        _obscureText = obscureText,
        _enableInteractiveSelection = enableInteractiveSelection,
        _contentPadding = contentPadding,
        _onChanged = onChanged,
        super(key: key);

  final TextEditingController _controller;
  final String _label;
  final String _errorText;
  final TextInputType _keyboardType;
  final int _maxLength;
  final FormFieldValidator<String> _validator;
  final List<TextInputFormatter> _inputFormatters;
  final GestureTapCallback _onTap;
  final bool _readOnly;
  final bool _obscureText;
  final FocusNode _focusNode;
  final bool _enableInteractiveSelection;
  final EdgeInsetsGeometry _contentPadding;
  final ValueChanged<String> _onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        enableInteractiveSelection: _enableInteractiveSelection,
        controller: _controller,
        focusNode: _focusNode,
        obscureText: _obscureText,
        keyboardType: _keyboardType,
        maxLength: _maxLength,
        validator: _validator,
        inputFormatters: _inputFormatters,
        onTap: _onTap,
        readOnly: _readOnly,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
        onChanged: _onChanged,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: _contentPadding,
          labelText: _label,
          errorText: _errorText,
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
      ),
    );
  }
}
