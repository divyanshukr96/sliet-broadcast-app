import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sliet_broadcast/components/register.dart';
import 'package:sliet_broadcast/components/terms_conditions.dart';
import 'package:sliet_broadcast/style/theme.dart' as Theme;
import 'package:sliet_broadcast/utils/network_utils.dart';

class FacultyRegister extends StatefulWidget {
  final Map<String, dynamic> faculty;

  const FacultyRegister({@required this.faculty});

  @override
  _FacultyRegisterState createState() => _FacultyRegisterState();
}

class _FacultyRegisterState extends State<FacultyRegister> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _fieldError = Map();
  List<String> _serverError = List();
  ProgressDialog pr;

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _mobileController = new TextEditingController();
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _departmentController = new TextEditingController();
  TextEditingController _designationController = new TextEditingController();
  TextEditingController _genderController = new TextEditingController();
  TextEditingController _dobController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    try {
      _nameController.text = widget.faculty['name'];
      _emailController.text = widget.faculty['email'];
      _mobileController.text = widget.faculty['mobile'];
      _designationController.text = widget.faculty['designation'];
      _departmentController.text = widget.faculty['department'];
      _genderController.text = widget.faculty['gender'];
      _dobController.text = widget.faculty['dob'];
    } catch (error) {
      print('facilty_register init Error $error');
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

    if (_genderController.text.isEmpty)
      _fieldError.addAll({'gender': 'Please select the gender field'});
    else
      _fieldError.remove('gender');
    setState(() {});

    if (_formKey.currentState.validate() && _fieldError.isEmpty) {
      FocusScope.of(context).requestFocus(new FocusNode());
      pr.show();
      FormData formData = FormData.from({
        'name': _nameController.text,
        'email': _emailController.text,
        'mobile': _mobileController.text,
        'username': _usernameController.text,
        'password': _passwordController.text,
        'department': _departmentController.text,
        'designation': _designationController.text,
        'gender': _genderController.text,
        'dob': _dobController.text,
      });

      try {
        dio.options.headers['content-type'] =
            "application/x-www-form-urlencoded";
        dio.options.headers['Accept'] = "application/json";
        response = await dio.post(
          NetworkUtils.host + "/api/auth/register/faculty",
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
            _designationController.clear();
            _genderController.clear();
            _dobController.clear();
          });
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
        print('facilty_register on_submit Error $e');
      }
    }
    pr.hide();
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Faculty Registration'),
      ),
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  InputTextForm(
                    controller: _nameController,
//                      focusNode: _nameFocus,
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
                    readOnly: true,
                    enableInteractiveSelection: false,
                    controller: _emailController,
                    label: 'Email address',
                  ),
                  InputTextForm(
                    controller: _mobileController,
//                      focusNode: _mobileFocus,
                    label: 'Mobile number',
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      BlacklistingTextInputFormatter(RegExp(" "))
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
//                      focusNode: _usernameFocus,
                    label: 'Username',
                    inputFormatters: [
                      BlacklistingTextInputFormatter(RegExp(" "))
                    ],
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
//                      focusNode: _passwordFocus,
                    label: 'Confirm Password',
                    obscureText: true,
                    inputFormatters: [
                      BlacklistingTextInputFormatter(RegExp(" "))
                    ],
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be atleast 6 charater';
                      }
                      return null;
                    },
                  ),
                  InputTextForm(
                    readOnly: true,
                    enableInteractiveSelection: false,
                    controller: _departmentController,
                    label: 'Department',
                  ),
                  InputTextForm(
                    controller: _designationController,
//                      focusNode: _nameFocus,
                    label: 'Designation',
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter current designation';
                      }
                      if (value.length < 2) {
                        return 'Designation must be at lest 2 charater';
                      }
                      return null;
                    },
                  ),
                  buildGenderRow(),
                  InputTextForm(
                    controller: _dobController,
//                      focusNode: _dobFocus,
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
                      child: Text('Submit Registration'),
                    ),
                  ),
                  SizedBox(height: 8.0)
                ],
              ),
            ),
          ),
        ),
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
                  height: 120.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/splash_screen.png'),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Thank you',
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
                    'Your registration process is now complete you may now login using your email/username and password.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17.0,
                      color: Colors.white70,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  textDirection: TextDirection.rtl,
                  children: <Widget>[
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
                    FlatButton(
                      splashColor: Colors.lightBlue,
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                      child: Text(
                        "Login",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontFamily: "WorkSansMedium",
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
