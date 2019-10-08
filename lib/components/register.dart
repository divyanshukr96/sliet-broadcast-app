import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sliet_broadcast/components/terms_conditions.dart';
import 'package:sliet_broadcast/style/theme.dart' as Theme;
import 'package:sliet_broadcast/utils/network_utils.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  List<dynamic> _departments = new List();
  List<dynamic> _program = new List();
  Map<String, dynamic> _fieldError = Map();
  List<String> _serverError = List();
  ProgressDialog pr;

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
  final FocusNode _departmentFocus = FocusNode();
  final FocusNode _batchFocus = FocusNode();
  final FocusNode _registrationFocus = FocusNode();
  final FocusNode _programFocus = FocusNode();
  final FocusNode _genderFocus = FocusNode();
  final FocusNode _dobFocus = FocusNode();

  @override
  void initState() {
    _fetchDepartment();
    super.initState();
  }

  _fetchDepartment() async {
    dynamic data = await NetworkUtils.get('/api/public/department');
    dynamic program = await NetworkUtils.get('/api/public/program');
    try {
      if (data != null)
        setState(() {
          _departments = data;
          _program = program;
        });
    } catch (e) {
      print('Error $e');
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'Something went wrong.',
          style: TextStyle(color: Colors.white70, fontSize: 16.0),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  DateTime selectedDate = DateTime.now().subtract(Duration(days: 5000));

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1800, 8),
      lastDate: DateTime(DateTime.now().year - 12),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _dobController.text = picked.toString().split(" ")[0];
      });
  }

  _handleSubmit() async {
    pr.style(message: 'Form submitting ...');
    Response response;
    Dio dio = new Dio();

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

    if (_formKey.currentState.validate() && _fieldError.isEmpty) {
      pr.show();
      FormData formData = FormData.from({
        'name': _nameController.text,
        'email': _emailController.text,
        'mobile': _mobileController.text,
        'username': _usernameController.text,
        'password': _passwordController.text,
        'department': _departmentController.text,
        'registration_number': _registrationController.text,
        'program': _programController.text,
        'gender': _genderController.text,
        'batch': _batchController.text,
        'dob': _dobController.text,
      });

      try {
        dio.options.headers['content-type'] =
            "application/x-www-form-urlencoded";
        dio.options.headers['Accept'] = "application/json";
        response = await dio.post(
          NetworkUtils.host + "/api/auth/register",
          data: formData,
        );

        if (response.statusCode == 201) {
          _formKey.currentState.reset();
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
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(
              'You are successfully registered',
              style: TextStyle(color: Colors.white70, fontSize: 18.0),
            ),
            backgroundColor: Colors.green,
          ));
          Future.delayed(const Duration(milliseconds: 1000), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => RegistrationSuccess(),
              ),
            );
          });
        }
      } on DioError catch (e) {
        pr.hide();
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
        }
      } catch (e) {
        print('Error $e');
      }
    }
    pr.hide();
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('New Registration')),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                InputTextForm(
                  controller: _nameController,
                  focusNode: _nameFocus,
                  label: 'Full Name',
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter full name';
                    }
                    if (value.length < 5) {
                      return 'Name must be more than 5 charater';
                    }
                    return null;
                  },
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
                    if (value.isEmpty) return 'Please enter email address';
                    Pattern pattern =
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                    RegExp regex = new RegExp(pattern);
                    if (!regex.hasMatch(value))
                      return 'Enter valid email address';
                    return null;
                  },
                ),
                InputTextForm(
                  controller: _mobileController,
                  focusNode: _mobileFocus,
                  label: 'Mobile number',
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter mobile number';
                    }
                    if (value.length < 10) {
                      return 'Mobile number should be of 10 digit';
                    }
                    return null;
                  },
                ),
                InputTextForm(
                  controller: _usernameController,
                  focusNode: _usernameFocus,
                  label: 'Username',
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter username';
                    }
                    if (value.length < 4) {
                      return 'Username must be more than 5 charater';
                    }
                    return null;
                  },
                ),
                InputTextForm(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  label: 'Password',
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter password';
                    }
                    if (value.length < 6) {
                      return 'Password must be atleast 6 charater';
                    }
                    return null;
                  },
                ),
                buildDepartmentField(),
                InputTextForm(
                  controller: _batchController,
                  focusNode: _batchFocus,
                  label: 'Batch (YYYY)',
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your batch';
                    }
                    if ((int.parse(value) > DateTime.now().year) ||
                        value.length < 4) {
                      return 'Entered batch year is invalid';
                    }
                    if ((int.parse(value) == DateTime.now().year) &&
                        DateTime.now().month < 6) {
                      return 'Entered value is invalid';
                    }
                    return null;
                  },
                ),
                InputTextForm(
                  controller: _registrationController,
                  focusNode: _registrationFocus,
                  label: 'Registration number',
                  keyboardType: TextInputType.number,
                  maxLength: 7,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your registration number';
                    }
                    if (value.length < 4) {
                      return 'Invalid registration number';
                    }
                    return null;
                  },
                ),
                buildProgramField(),
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
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    onPressed: () {
                      _handleSubmit();
                    },
                    child: Text('Register'),
                  ),
                ),
                SizedBox(height: 8.0)
              ],
            ),
          ),
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

  Padding buildDepartmentField() {
    if (!FocusScope.of(context).hasFocus)
      FocusScope.of(context).requestFocus(new FocusNode());

    var value;
    if (_departmentController.text != "") {
      value = _departments
          .where((d) => d['username'] == _departmentController.text)
          .toList()[0]['name'];
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
            'Department',
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
            items: _departments
                .map((data) => DropdownMenuItem<String>(
                      child: Text(data['name']),
                      value: data['username'],
                    ))
                .toList(),
            onChanged: (String value) {
              setState(() => _departmentController.text = value);
            },
            hint: Text(value != null ? value : 'Select Your Department'),
          ),
          RegisterFieldError(error: _fieldError, name: 'department')
        ],
      ),
    );
  }

  Padding buildProgramField() {
    var value = "";
    if (_programController.text != "") {
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
            items: _program
                .map((data) => DropdownMenuItem<String>(
                      child: Text(data[1]),
                      value: data[0],
                    ))
                .toList(),
            onChanged: (String value) {
              setState(() => _programController.text = value);
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
}

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
    TextInputType keyboardType,
    int maxLength,
    FormFieldValidator<String> validator,
    List<TextInputFormatter> inputFormatters,
    GestureTapCallback onTap,
    bool readOnly = false,
    bool obscureText = false,
  })  : _controller = controller,
        _focusNode = focusNode,
        _label = label,
        _keyboardType = keyboardType,
        _maxLength = maxLength,
        _validator = validator,
        _inputFormatters = inputFormatters,
        _onTap = onTap,
        _readOnly = readOnly,
        _obscureText = obscureText,
        super(key: key);

  final TextEditingController _controller;
  final String _label;
  final TextInputType _keyboardType;
  final int _maxLength;
  final FormFieldValidator<String> _validator;
  final List<TextInputFormatter> _inputFormatters;
  final GestureTapCallback _onTap;
  final bool _readOnly;
  final bool _obscureText;
  final FocusNode _focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
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
          fontFamily: "WorkSansSemiBold",
          fontSize: 16.0,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          labelText: _label,
          hintStyle: TextStyle(fontFamily: "WorkSansSemiBold", fontSize: 17.0),
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

class RegistrationSuccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
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
        child: Card(
          color: Colors.transparent,
          margin: EdgeInsets.all(16.0),
//          elevation: 5.0,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 120.0,
                  height: 120.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/login.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Thank you for registering with us.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Your account will be activated after your details have been verified by the Administrator.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17.0,
                      color: Colors.white70,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'It may take some time for the verification to complete.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white60,
                    ),
                  ),
                ),
                SizedBox(height: 24.0),
                FlatButton(
                  splashColor: Colors.lightBlue,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => TermsAndConditions(),
                      ),
                    );
                  },
                  child: Text(
                    "Read terms and conditions",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white54,
                      decoration: TextDecoration.underline,
                      fontSize: 16.0,
                      fontFamily: "WorkSansMedium",
                    ),
                  ),
                ),
                SizedBox(height: 24.0),
                FlatButton(
                  splashColor: Colors.lightBlue,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Back",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
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
    );
  }
}
