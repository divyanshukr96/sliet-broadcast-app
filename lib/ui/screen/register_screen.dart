import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sliet_broadcast/core/models/department.dart';
import 'package:sliet_broadcast/core/models/register.dart';
import 'package:sliet_broadcast/core/constant.dart';
import 'package:sliet_broadcast/core/viewmodels/views/register_model.dart';
import 'package:sliet_broadcast/ui/widgets/custom_input.dart';
import 'package:sliet_broadcast/ui/widgets/registration_success.dart';
import 'package:sliet_broadcast/views/base_widget.dart';



class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  Register _student = Register();

  Map<String, dynamic> _fieldError = Map();
  List<String> _serverError = List();

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _mobileController = new TextEditingController();
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _departmentController = new TextEditingController();
  TextEditingController _batchController = new TextEditingController();
  TextEditingController _registrationController = new TextEditingController();
  TextEditingController _programController = new TextEditingController();
  TextEditingController _genderController = new TextEditingController();
  TextEditingController _dobController = new TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _mobileFocus = FocusNode();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _batchFocus = FocusNode();
  final FocusNode _registrationFocus = FocusNode();
  final FocusNode _dobFocus = FocusNode();

  DateTime selectedDate = DateTime.now().subtract(Duration(days: 5000));

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1800, 8),
      lastDate: DateTime(DateTime.now().year - 12),
    );
    if (picked != null && picked != selectedDate) {
      String _dob = picked.toString().split(" ")[0];
      setState(() {
        selectedDate = picked;
        _dobController.text = _dob;
      });
      _student.dob = _dob;
    }
  }

  _handleSubmit(RegisterModel model) async {
    try {
      await model.register(_student);
      _formKey.currentState.reset();
      _clearController();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'You are successfully registered',
          style: TextStyle(color: Colors.white70, fontSize: 18.0),
        ),
        backgroundColor: Colors.green,
      ));
      Future.delayed(const Duration(milliseconds: 200), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => RegistrationSuccess(),
          ),
        );
      });
    } on DioError catch (e) {
      if (e.response.statusCode == 400 && e.response.data != null) {
        Map<String, dynamic> _error = e.response.data;
        _error.forEach((key, value) {
          _serverError.add(value[0]);
        });
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            _serverError[0],
            style: TextStyle(color: Colors.white70),
          ),
          backgroundColor: Colors.deepOrange,
        ));
        _serverError.clear();
      } else {
        print('RegisterScreen _handleSubmit DioError : $e');
      }
    } catch (e) {
      print('RegisterScreen _handleSubmit Error : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('New Registration')),
      body: SingleChildScrollView(
        child: BaseWidget(
          model: RegisterModel(api: Provider.of(context)),
          onModelReady: (model) => model.initialize(),
          builder: (context, RegisterModel model, _) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
              child: SafeArea(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      InputTextForm(
                        controller: _nameController,
                        focusNode: _nameFocus,
                        label: 'Full Name',
                        validator: (value) {
                          if (value.isEmpty) return 'Please enter full name';
                          if (value.length < 5)
                            return 'Name must be more than 5 charater';
                          return null;
                        },
                        onChanged: (value) => _student.name = value,
                      ),
                      InputTextForm(
                        controller: _emailController,
                        focusNode: _emailFocus,
                        label: 'Email address',
                        keyboardType: TextInputType.emailAddress,
                        inputFormatters: [
                          BlacklistingTextInputFormatter(RegExp(" "))
                        ],
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Please enter email address';
                          RegExp regex = new RegExp(emailPattern);
                          if (!regex.hasMatch(value))
                            return 'Enter valid email address';
                          return null;
                        },
                        onChanged: (value) => _student.email = value,
                      ),
                      InputTextForm(
                        controller: _mobileController,
                        focusNode: _mobileFocus,
                        label: 'Mobile number',
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          BlacklistingTextInputFormatter(RegExp(" "))
                        ],
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Please enter mobile number';
                          if (value.length < 10)
                            return 'Mobile number should be of 10 digit';
                          return null;
                        },
                        onChanged: (value) => _student.mobile = value,
                      ),
                      InputTextForm(
                        controller: _usernameController,
                        focusNode: _usernameFocus,
                        label: 'Username',
                        inputFormatters: [
                          BlacklistingTextInputFormatter(RegExp(" ")),
                        ],
                        validator: (value) {
                          if (value.isEmpty) return 'Please enter username';
                          if (value.length < 4)
                            return 'Username must be more than 5 charater';
                          return null;
                        },
                        onChanged: (value) =>
                            _student.username = value.toLowerCase(),
                      ),
                      InputTextForm(
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        label: 'Password',
                        obscureText: true,
                        inputFormatters: [
                          BlacklistingTextInputFormatter(RegExp(" "))
                        ],
                        validator: (value) {
                          if (value.isEmpty) return 'Please enter password';
                          if (value.length < 6)
                            return 'Password must be atleast 6 charater';
                          return null;
                        },
                        onChanged: (value) => _student.password = value,
                      ),
                      buildDepartmentField(model.departments),
                      InputTextForm(
                        controller: _batchController,
                        focusNode: _batchFocus,
                        label: 'Batch (YYYY)',
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          BlacklistingTextInputFormatter(RegExp(" "))
                        ],
                        validator: (value) {
                          if (value.isEmpty) return 'Please enter your batch';
                          DateTime _curr = DateTime.now();
                          int _value = int.parse(value);
                          if ((_value > _curr.year) || value.length < 4) {
                            return 'Entered batch year is invalid';
                          }
                          if ((_value == _curr.year) && _curr.month < 6) {
                            return 'Entered value is invalid';
                          }
                          return null;
                        },
                        onChanged: (value) => _student.batch = value,
                      ),
                      InputTextForm(
                        controller: _registrationController,
                        focusNode: _registrationFocus,
                        label: 'Registration number',
                        keyboardType: TextInputType.number,
                        maxLength: 7,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          BlacklistingTextInputFormatter(RegExp(" "))
                        ],
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Please enter your registration number';
                          if (value.length < 4)
                            return 'Invalid registration number';
                          return null;
                        },
                        onChanged: (value) =>
                            _student.registrationNumber = value,
                      ),
                      buildProgramField(model.programs),
                      buildGenderRow(),
                      InputTextForm(
                        controller: _dobController,
                        focusNode: _dobFocus,
                        label: 'DOB (YYYY-MM-DD)',
                        readOnly: true,
                        onTap: () {
                          _selectDate(context);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: RaisedButton(
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 64.0),
                          onPressed: () async {
                            if (await _validateFields()) {
                              _handleSubmit(model);
                            }
                          },
                          child: Text('Register'),
                        ),
                      ),
                      Text(
                        'For any query contact ACSS Section CSE Dept.',
                        style: Theme.of(context).textTheme.caption.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(height: 8.0)
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    _emailFocus.dispose();
    _mobileFocus.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    _batchFocus.dispose();
    _registrationFocus.dispose();
    _dobFocus.dispose();
    super.dispose();
  }

  Padding buildDepartmentField(_dept) {
    if (!FocusScope.of(context).hasFocus)
      FocusScope.of(context).requestFocus(new FocusNode());

    Department value;
    if (_departmentController.text.isNotEmpty) {
      value = _dept
          .where((d) => d.username == _departmentController.text)
          .toList()[0];
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Department',
            textAlign: TextAlign.start,
            style: TextStyle(
              color: value != null ? Colors.blueAccent : Colors.black54,
            ),
          ),
          DropdownButton<String>(
            isExpanded: true,
            underline: Container(
              height: 1.2,
              color: Colors.blue,
            ),
            items: List<DropdownMenuItem<String>>.from(
              _dept.map(
                (Department data) => DropdownMenuItem<String>(
                  child: Text(data.name),
                  value: data.username,
                ),
              ),
            ),
            onChanged: (String value) {
              _student.department = value;
              setState(() => _departmentController.text = value);
            },
            hint: Text(value != null ? value.name : 'Select Your Department'),
          ),
          RegisterFieldError(error: _fieldError, name: 'department')
        ],
      ),
    );
  }

  Padding buildProgramField(_program) {
    var value = "";
    if (_programController.text.isNotEmpty) {
      value =
          _program.where((d) => d[0] == _programController.text).toList()[0][1];
    }
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Program',
            textAlign: TextAlign.start,
            style: TextStyle(
              color: value != "" ? Colors.blueAccent : Colors.black54,
            ),
          ),
          DropdownButton<String>(
            isExpanded: true,
            underline: Container(
              height: 1.2,
              color: Colors.blue,
            ),
            items: List<DropdownMenuItem<String>>.from(
              _program.map(
                (data) => DropdownMenuItem<String>(
                  child: Text(data[1]),
                  value: data[0],
                ),
              ),
            ),
            onChanged: (String value) {
              setState(() => _programController.text = value);
              _student.program = value;
            },
            hint: Text(value != "" ? value : 'Select Your Program'),
          ),
          RegisterFieldError(error: _fieldError, name: 'program')
        ],
      ),
    );
  }

  Padding buildGenderRow() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        top: 8.0,
        bottom: 8.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(
                flex: 5,
                child: Text(
                  'Gender',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: _genderController.text != ""
                        ? Colors.blueAccent
                        : Colors.black54,
                  ),
                ),
              ),
              Flexible(
                flex: 14,
                child: RadioListTile<String>(
                  title: new Text('Male'),
                  value: 'MALE',
                  groupValue: _genderController.text,
                  onChanged: (String value) {
                    _student.gender = value;
                    setState(() {
                      _genderController.text = value;
                    });
                  },
                ),
              ),
              Flexible(
                flex: 15,
                child: RadioListTile<String>(
                  title: new Text('Female'),
                  value: 'FEMALE',
                  groupValue: _genderController.text,
                  onChanged: (String value) {
                    _student.gender = value;
                    setState(() {
                      _genderController.text = value;
                    });
                  },
                ),
              ),
            ],
          ),
          RegisterFieldError(error: _fieldError, name: 'gender')
        ],
      ),
    );
  }

  Future<bool> _validateFields() async {
    if (_departmentController.text.isEmpty)
      _fieldError.addAll({'department': 'Please select your department'});
    else
      _fieldError.remove('department');
    if (_programController.text.isEmpty)
      _fieldError.addAll({'program': 'Please select your program'});
    else
      _fieldError.remove('program');
    if (_genderController.text.isEmpty)
      _fieldError.addAll({'gender': 'Please select the gender field'});
    else
      _fieldError.remove('gender');
    setState(() {});
    return _formKey.currentState.validate() && _fieldError.isEmpty;
  }

  void _clearController() {
    setState(() {
      _nameController.clear();
      _emailController.clear();
      _mobileController.clear();
      _usernameController.clear();
      _passwordController.clear();
      _departmentController.clear();
      _registrationController.clear();
      _programController.clear();
      _genderController.clear();
      _batchController.clear();
      _dobController.clear();
    });
  }
}
