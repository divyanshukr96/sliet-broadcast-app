import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sliet_broadcast/core/constant.dart';
import 'package:sliet_broadcast/core/viewmodels/views/password_reset_modal.dart';
import 'package:sliet_broadcast/ui/widgets/custom_input.dart';
import 'package:sliet_broadcast/views/base_widget.dart';

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

  _confirmOTP(PasswordResetModal model) async {
    FocusScope.of(context).requestFocus(new FocusNode());
    try {
      String token = await model.confirmOtp(
        token: widget.token,
        otp: _otpController.text,
      );
      _authTokenController.text = token;
      setState(() {
        crossFadeState = CrossFadeState.showSecond;
      });
    } on DioError catch (e) {
      if (e.response.statusCode == 400 && e.response.data != null) {
        setState(() {
          _otperror = e.response.data['otp'][0];
        });
      } else {
        print('PasswordReset _confirmOTP DioError : $e');
      }
    } catch (e) {
      print('PasswordReset _confirmOTP Error : $e');
    }
  }

  _submitPassword(PasswordResetModal model) async {
    Dio _dio = new Dio();
    FocusScope.of(context).requestFocus(new FocusNode());
    _dio.options.headers['Authorization'] =
        "Token " + _authTokenController.text;
    if (_passwordKey.currentState.validate())
      try {
        await _dio.post(
          '${model.endPoint}/password/change',
          data: {
            'password': _passwordController.text,
            'token': _tokenController.text,
          },
        );
        setState(() {
          _success = true;
        });
      } on DioError catch (e) {
        print('PasswordReset _submitPassword onDioerror ${e.response}');
      } catch (e) {
        print('PasswordReset _submitPassword $e');
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
        child: BaseWidget(
          model: PasswordResetModal(api: Provider.of(context)),
          builder: (context, PasswordResetModal model, _) {
            return AnimatedCrossFade(
              firstChild: buildOTPVerification(model),
              secondChild: buildPasswordChange(model),
              crossFadeState: crossFadeState,
              duration: Duration(milliseconds: 500),
            );
          },
        ),
      ),
    );
  }

  Builder buildOTPVerification(PasswordResetModal model) {
    return Builder(
      builder: (context) {
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
                        fontSize: 17.0,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.lightBlueAccent,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.redAccent,
                          width: 1.0,
                        ),
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
                        _confirmOTP(model);
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
      },
    );
  }

  Builder buildPasswordChange(PasswordResetModal model) {
    return Builder(
      builder: (context) {
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
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
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
                                _submitPassword(model);
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
      },
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

class PasswordResetRequest extends StatefulWidget {
  const PasswordResetRequest({
    Key key,
  }) : super(key: key);

  @override
  _PasswordResetRequestState createState() => _PasswordResetRequestState();
}

class _PasswordResetRequestState extends State<PasswordResetRequest> {
  final TextEditingController _emailController = new TextEditingController();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  String _emailError;

  _sendOTPRequest(PasswordResetModal model) async {
    if (_formKey.currentState.validate()) {
      FocusScope.of(context).requestFocus(new FocusNode());
      try {
        String token = await model.requestOtp(email: _emailController.text);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => PasswordReset(token),
        ));
      } on DioError catch (e) {
        if (e.response.statusCode == 400 && e.response.data != null) {
          setState(() {
            _emailError = e.response.data['email'][0];
          });
        }
      } catch (e) {
        print('PasswordResetRequest _sendOTPRequest $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(gradient: LoginLinearGradient()),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Card(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
              child: BaseWidget(
                model: PasswordResetModal(api: Provider.of(context)),
                builder: (context, PasswordResetModal model, _) {
                  return Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Forgot password',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.black54,
                        height: 32,
                      ),
                      InputTextForm(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        label: "Enter registered email",
                        errorText: _emailError,
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
                      ),
                      SizedBox(height: 12.0),
                      RaisedButton(
                        padding: EdgeInsets.symmetric(horizontal: 48.0),
                        color: Colors.blueAccent,
                        textColor: Colors.white,
                        onPressed: () async {
                          _sendOTPRequest(model);
                        },
                        child: Text('Send OTP'),
                      ),
                      FlatButton(
                        textColor: Colors.redAccent,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Back',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
