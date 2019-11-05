import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sliet_broadcast/components/register.dart';
import 'package:sliet_broadcast/utils/network_utils.dart';

class PasswordReset extends StatefulWidget {
  final String token;

  PasswordReset(this.token);

  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _passwordKey = new GlobalKey<FormState>();

  final TextEditingController _tokenController = new TextEditingController();
  final TextEditingController _authTokenController =
      new TextEditingController();
  final TextEditingController _otpController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _passConfController = new TextEditingController();
  CrossFadeState crossFadeState = CrossFadeState.showFirst;

  String _otperror;
  bool _success = false;

  _confirmOTP(context) async {
    FocusScope.of(context).requestFocus(new FocusNode());
    try {
      dynamic token = await NetworkUtils.post('/api/password/reset/confirm', {
        'token': _tokenController.text,
        'otp': _otpController.text,
      });
      setState(() {
        _otperror = token['errors'] != null ? token['errors']['otp'][0] : null;
      });
      if (token['token'] != null) {
        _authTokenController.text = token['token'];
        setState(() {
          crossFadeState = CrossFadeState.showSecond;
        });
      }
    } catch (e) {
      print('password_reset _sendOTPRequest $e');
    }
  }

  _submitPassword(context) async {
    Dio _dio = new Dio();
    FocusScope.of(context).requestFocus(new FocusNode());
    _dio.options.headers['Authorization'] =
        "Token " + _authTokenController.text;
    if (_passwordKey.currentState.validate())
      try {
        await _dio.post(
          NetworkUtils.host + '/api/password/change',
          data: {
            'password': _passwordController.text,
            'token': _tokenController.text,
          },
        );
        setState(() {
          _success = true;
        });
      } on DioError catch (e) {
        print('password_reset _submit password onDioerror ${e.response}');
      } catch (e) {
        print('password_reset _sendOTPRequest $e');
      }
  }

  @override
  void initState() {
    super.initState();
    _tokenController.text = widget.token;
  }

  get _getVerificationCodeLabel {
    return new Text(
      "Verification Code",
      textAlign: TextAlign.center,
      style: new TextStyle(
        fontSize: 24.0,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  get _getEmailLabel {
    return new Text(
      "Please enter the OTP sent\non your registered Email ID.",
      textAlign: TextAlign.center,
      style: new TextStyle(
        fontSize: 16.0,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: AnimatedCrossFade(
          firstChild: buildOTPVerification(context),
          secondChild: buildPasswordChange(context),
          crossFadeState: crossFadeState,
          duration: Duration(milliseconds: 500),
        ),
      ),
    );
  }

  Container buildOTPVerification(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      height: 420,
      child: Card(
        elevation: 5.0,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SizedBox(height: 0.0),
            _getVerificationCodeLabel,
            _getEmailLabel,
            SizedBox(
              width: 200,
              child: TextFormField(
                enableInteractiveSelection: false,
                controller: _otpController,
                keyboardType: TextInputType.text,
                maxLength: 6,
                style: TextStyle(
                  fontFamily: "WorkSansSemiBold",
                  fontSize: 18.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 17.0,
                ),
                inputFormatters: [
                  BlacklistingTextInputFormatter(RegExp(" ")),
                ],
                validator: (value) {
                  if (value.isEmpty) return 'Please OTP';
                  if (value.length < 6) return 'Enter valid OTP';
                  return null;
                },
                decoration: InputDecoration(
                  errorText: _otperror,
                  hintStyle: TextStyle(
                    fontFamily: "WorkSansSemiBold",
                    fontSize: 17.0,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.lightBlueAccent, width: 1.0),
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
            ),
            Column(
              children: <Widget>[
                RaisedButton(
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  onPressed: () {
                    _confirmOTP(context);
                  },
                  child: Text('Confirm OTP'),
                ),
                FlatButton(
                  textColor: Colors.black54,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Container buildPasswordChange(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      height: 420,
      child: Card(
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: _success
                ? SuccessPasswordChange()
                : Form(
                    key: _passwordKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        SizedBox(height: 0.0),
                        Text(
                          "Reset your password",
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                              fontSize: 24.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            "Please choose a new password to finish signing in.",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        InputTextForm(
                          controller: _passwordController,
                          label: 'New password',
                          obscureText: true,
                          inputFormatters: [
                            BlacklistingTextInputFormatter(RegExp(" "))
                          ],
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
                        InputTextForm(
                          controller: _passConfController,
                          label: 'Confirm new password',
                          obscureText: true,
                          inputFormatters: [
                            BlacklistingTextInputFormatter(RegExp(" "))
                          ],
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter confirm password';
                            }
                            if (_passwordController.text !=
                                _passConfController.text) {
                              return 'Confirm password not match';
                            }
                            return null;
                          },
                        ),
                        RaisedButton(
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          onPressed: () {
                            _submitPassword(context);
                          },
                          child: Text('Submit'),
                        )
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class SuccessPasswordChange extends StatelessWidget {
  const SuccessPasswordChange({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Tab(
              icon: Icon(Icons.check_circle_outline,
                  size: 60.0, color: Colors.green),
            )
          ],
        ),
        SizedBox(height: 80.0),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Password Successfully Changed!",
              textAlign: TextAlign.center,
              style: new TextStyle(
                fontSize: 18.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "You can now use your new password.",
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(height: 64.0),
        Center(
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            color: Colors.blueAccent,
            textColor: Colors.white,
            child: Text('Login'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        )
      ],
    );
  }
}
