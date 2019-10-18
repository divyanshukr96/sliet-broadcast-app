import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliet_broadcast/utils/network_utils.dart';
import 'package:sliet_broadcast/utils/auth_utils.dart';
import 'package:sliet_broadcast/style/theme.dart' as Theme;

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  NetworkUtils networkUtils = new NetworkUtils();

  bool loading = false;

  final FocusNode currentFocusNodePassword = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();
  TextEditingController currentPasswordController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  bool _obscureTextLogin = true;
  bool _obscureTextLoginCurrent = true;

  _submitForm() async {
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
        print("change_password _submitForm Error $e");
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
      height: MediaQuery.of(context).size.height * .2,
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
                  const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(
                        'Change password',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    height: 36.0,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10.0, bottom: 20.0, left: 25.0, right: 25.0),
                    child: TextFormField(
                      enableInteractiveSelection: false,
                      focusNode: currentFocusNodePassword,
                      controller: currentPasswordController,
                      obscureText: _obscureTextLoginCurrent,
                      inputFormatters: [
                        BlacklistingTextInputFormatter(RegExp(" ")),
                      ],
                      style: TextStyle(
                        fontFamily: "WorkSansSemiBold",
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.lock_outline,
                          size: 22.0,
                          color: Colors.black,
                        ),
                        hintText: "Current Password",
                        hintStyle: TextStyle(
                            fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureTextLoginCurrent =
                                  !_obscureTextLoginCurrent;
                            });
                          },
                          child: Icon(
                            _obscureTextLoginCurrent
                                ? FontAwesomeIcons.eye
                                : FontAwesomeIcons.eyeSlash,
                            size: 15.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10.0, bottom: 20.0, left: 25.0, right: 25.0),
                    child: TextFormField(
                      enableInteractiveSelection: false,
                      focusNode: myFocusNodePasswordLogin,
                      controller: loginPasswordController,
                      obscureText: _obscureTextLogin,
                      inputFormatters: [
                        BlacklistingTextInputFormatter(RegExp(" ")),
                      ],
                      style: TextStyle(
                          fontFamily: "WorkSansSemiBold",
                          fontSize: 16.0,
                          color: Colors.black),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.lock_outline,
                          size: 22.0,
                          color: Colors.black,
                        ),
                        hintText: "New Password",
                        hintStyle: TextStyle(
                            fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                        suffixIcon: GestureDetector(
                          onTap: _toggleLogin,
                          child: Icon(
                            _obscureTextLogin
                                ? FontAwesomeIcons.eye
                                : FontAwesomeIcons.eyeSlash,
                            size: 15.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: RaisedButton(
                      highlightColor: Colors.transparent,
                      splashColor: Theme.Colors.loginGradientEnd,
                      textColor: Colors.white,
                      color: loading ? Colors.white12 : Colors.lightBlueAccent,
                      child: Text("Change Password"),
                      onPressed: loading ? () {} : _submitForm,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FlatButton(
                        splashColor: Colors.lightBlue,
                        onPressed: _backAction,
                        child: Text(
                          "Back",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 18.0,
                            fontFamily: "WorkSansMedium",
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
