import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sliet_broadcast/core/constant.dart';
import 'package:sliet_broadcast/core/viewmodels/views/password_reset_modal.dart';
import 'package:sliet_broadcast/utils/network_utils.dart';
import 'package:sliet_broadcast/style/theme.dart' as Theme;
import 'package:sliet_broadcast/views/base_widget.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  NetworkUtils networkUtils = new NetworkUtils();

  final FocusNode currentFocusNodePassword = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();
  TextEditingController currentPasswordController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  bool _obscureTextLogin = true;
  bool _obscureTextLoginCurrent = true;

  _submitForm(PasswordResetModal model) async {
    try {
      await model.changePassword(
        password: currentPasswordController.text,
        newPassword: loginPasswordController.text,
      );
      _backAction();
    } on DioError catch (e) {
      print("ChangePassword _submitForm DioError $e");
    } catch (err) {
      print("ChangePassword _submitForm Error $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(gradient: LoginLinearGradient()),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: BaseWidget(
          model: PasswordResetModal(api: Provider.of(context)),
          builder: (context, PasswordResetModal model, _) {
            return Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Change password',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Divider(
                      height: 32.0,
                      color: Colors.black,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                      child: TextFormField(
                        enableInteractiveSelection: false,
                        focusNode: currentFocusNodePassword,
                        controller: currentPasswordController,
                        obscureText: _obscureTextLoginCurrent,
                        inputFormatters: [
                          BlacklistingTextInputFormatter(RegExp(" ")),
                        ],
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Color(0xfff3f3f4),
                          filled: true,
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            size: 22.0,
                            color: Colors.black,
                          ),
                          hintText: "Current Password",
                          hintStyle: TextStyle(
                            fontSize: 17.0,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureTextLoginCurrent =
                                    !_obscureTextLoginCurrent;
                              });
                            },
                            child: buildEyeIcon(_obscureTextLoginCurrent),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                      child: TextFormField(
                        enableInteractiveSelection: false,
                        focusNode: myFocusNodePasswordLogin,
                        controller: loginPasswordController,
                        obscureText: _obscureTextLogin,
                        inputFormatters: [
                          BlacklistingTextInputFormatter(RegExp(" ")),
                        ],
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Color(0xfff3f3f4),
                          filled: true,
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            size: 22.0,
                            color: Colors.black,
                          ),
                          hintText: "New Password",
                          hintStyle: TextStyle(fontSize: 17.0),
                          suffixIcon: GestureDetector(
                            onTap: _toggleLogin,
                            child: buildEyeIcon(_obscureTextLogin),
                          ),
                        ),
                      ),
                    ),
                    RaisedButton(
                      highlightColor: Colors.transparent,
                      splashColor: Theme.Colors.loginGradientEnd,
                      textColor: Colors.white,
                      color:
                          model.busy ? Colors.white12 : Colors.lightBlueAccent,
                      child: Text("Change Password"),
                      onPressed: () async {
                        if (model.busy) return;
                        if (_formKey.currentState.validate()) {
                          _submitForm(model);
                        }
                      },
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
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Icon buildEyeIcon(bool show) {
    return Icon(
      show ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
      size: 15.0,
      color: Colors.black,
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
