import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliet_broadcast/components/notice_form.dart';
import 'package:sliet_broadcast/utils/network_utils.dart';
import 'package:sliet_broadcast/utils/auth_utils.dart';
import 'package:sliet_broadcast/style/theme.dart' as Theme;

class EditNotice extends StatefulWidget {
  @override
  _EditNoticeState createState() => _EditNoticeState();
}

class _EditNoticeState extends State<EditNotice> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  NetworkUtils networkUtils = new NetworkUtils();

  bool loading = false;

  int selectedRadio;
  bool _isEvent = false;
  var selectedDepartment;
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  TextEditingController _titleController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();
  TextEditingController _venueController = new TextEditingController();

  ///////////////////////////////////////////////////

  final FocusNode currentFocusNodePassword = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();
  TextEditingController currentPasswordController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  bool _obscureTextLogin = true;
  bool _obscureTextLoginCurrent = true;

  _submitNewNotice() async {
    Response response;
    Dio dio = new Dio();
    String token = await networkUtils.getToken();

    final form = _formKey.currentState;

    if (form.validate()) {
      try {
        dio.options.headers['Authorization'] = "Token " + token;
        dio.options.headers['content-type'] =
            "application/x-www-form-urlencoded";
        dio.options.headers['Accept'] = "application/json";
        response = await dio.patch(
          NetworkUtils.productionHost + "/api/auth/user/password",
          data: FormData.from({
            'password': currentPasswordController.text,
            'new_password': loginPasswordController.text,
          }),
        );

        if (response.statusCode == 200) {
          final prefs = await SharedPreferences.getInstance();
          if (response.data['token'] != null) {
            prefs.setString(AuthUtils.authTokenKey, response.data['token']);
          }
          form.reset();
          loginPasswordController.clear();
          currentPasswordController.clear();
          _backAction();
        }
      } on DioError catch (e) {
//        print(e.response.data['detail']);
      }
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
//      height: MediaQuery.of(context).size.height * .2,
      padding: EdgeInsets.all(8.0),
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
      child: SingleChildScrollView(
        child: SafeArea(
          child: Card(
            elevation: 2.0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Form(
              key: _formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
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
                    TitleInput(controller: TextEditingController()),
                    DescriptionInput(controller: TextEditingController()),
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
                    DepartmentSelection(
                      value: selectedDepartment,
                      selectedDepartment: (departments) {
                        setState(() {
                          selectedDepartment = departments;
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: RaisedButton(
                        highlightColor: Colors.transparent,
                        splashColor: Theme.Colors.loginGradientEnd,
                        textColor: Colors.white,
                        color:
                            loading ? Colors.white12 : Colors.lightBlueAccent,
                        child: Text("Change Password"),
                        onPressed: loading ? () {} : _submitNewNotice,
                      ),
                    ),
                  ],
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
                  selectedRadio = val;
                });
              },
            ),
            Text('Faculty only'),
          ],
        ),
      ],
    );
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  void _backAction() {
    Navigator.pop(context);
  }
}
