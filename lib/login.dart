import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sliet_broadcast/components/faculty_register.dart';
import 'package:sliet_broadcast/components/password_reset.dart';
import 'package:sliet_broadcast/core/viewmodels/views/login_view_model.dart';
import 'package:sliet_broadcast/style/theme.dart' as Theme;
import 'package:sliet_broadcast/utils/network_utils.dart';
import 'package:sliet_broadcast/views/base_widget.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  bool _obscureTextLogin = false;

  Color left = Colors.black;
  Color right = Colors.white;

  final BoxDecoration _boxDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [Theme.Colors.loginGradientStart, Theme.Colors.loginGradientEnd],
      begin: const FractionalOffset(0.0, 0.0),
      end: const FractionalOffset(1.0, 1.0),
      stops: [0.0, 1.0],
      tileMode: TileMode.clamp,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        model: LoginViewModel(authenticationService: Provider.of(context)),
        builder: (context, model, child) {
          return Scaffold(
            key: _scaffoldKey,
            body: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overScroll) {
                overScroll.disallowGlow();
                return null;
              },
              child: SingleChildScrollView(
                  child: Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: _boxDecoration,
                    child: Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.1),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          SizedBox(
                            height: 40.0,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0, left: 50.0),
                            child: Image(
                              width: 100.0,
                              height: 100.0,
                              fit: BoxFit.fill,
                              image: AssetImage('assets/images/login.png'),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: _buildMenuBar(context),
                          ),
                          Expanded(
                            flex: 1,
                            child: PageView(
                              children: <Widget>[
                                new ConstrainedBox(
                                  constraints: const BoxConstraints.expand(),
                                  child: _buildSignIn(context, model),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 35.0,
                    right: 10.0,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close),
                      color: Colors.white,
                    ),
                  ),
                ],
              )),
            ),
          );
        });
  }

  @override
  void dispose() {
    myFocusNodeEmailLogin?.dispose();
    myFocusNodePasswordLogin?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  _authenticateUser(model) async {
    if (_formKey.currentState.validate()) {
      try {
        var response = await model.login(
          loginEmailController,
          loginPasswordController,
        );
        if (response['newUser'] != null) {
          return Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => FacultyRegister(
                faculty: response['newUser'],
              ),
            ),
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
        }
      } catch (e) {
        NetworkUtils.showSnackBar(_scaffoldKey, 'Invalid Email/Password');
      }
    }
  }

  Widget _buildMenuBar(BuildContext context) {
    return Container(
      width: 250.0,
      height: 40.0,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 5.0,
            spreadRadius: 1.0,
            offset: Offset(1.0, 1.0),
          )
        ],
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(28.0)),
      ),
      child: CustomPaint(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'SLIET Broadcast',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.w500,
                fontFamily: 'Montserrat',
                foreground: Paint()..shader = Theme.Colors.primaryTextGradient,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSignIn(BuildContext context, model) {
    TextStyle _textStyle = TextStyle(
      fontFamily: "WorkSansSemiBold",
      fontSize: 16.0,
      color: Colors.black,
    );
    TextStyle _hintStyle = TextStyle(
      fontFamily: "WorkSansSemiBold",
      fontSize: 17.0,
    );
    return Container(
      padding: EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * .9,
                  height: 200.0,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            top: 15.0,
                            left: 25.0,
                            right: 25.0,
                          ),
                          child: TextFormField(
                            focusNode: myFocusNodeEmailLogin,
                            controller: loginEmailController,
                            keyboardType: TextInputType.emailAddress,
                            inputFormatters: [
                              BlacklistingTextInputFormatter(RegExp(" "))
                            ],
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter valid username';
                              }
                              return null;
                            },
                            style: _textStyle,
                            decoration: InputDecoration(
//                            border: InputBorder.none,
                              icon: Icon(
                                Icons.person_outline,
                                color: Colors.black,
                                size: 22.0,
                              ),
                              hintText: "Email / Username",
                              hintStyle: _hintStyle,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 10.0,
                            bottom: 25.0,
                            left: 25.0,
                            right: 25.0,
                          ),
                          child: TextFormField(
                            enableInteractiveSelection: false,
                            focusNode: myFocusNodePasswordLogin,
                            controller: loginPasswordController,
                            obscureText: !_obscureTextLogin,
                            inputFormatters: [
                              BlacklistingTextInputFormatter(RegExp(" "))
                            ],
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter password';
                              }
                              return null;
                            },
                            style: _textStyle,
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.lock_outline,
                                size: 22.0,
                                color: Colors.black,
                              ),
                              hintText: "Password",
                              hintStyle: _hintStyle,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureTextLogin
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash,
                                  size: 16.0,
                                  color: Colors.black,
                                ),
                                onPressed: _toggleLogin,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 180.0),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Theme.Colors.loginGradientStart,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                    BoxShadow(
                      color: Theme.Colors.loginGradientEnd,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                  ],
                  gradient: new LinearGradient(
                    colors: [
                      Theme.Colors.loginGradientEnd,
                      Theme.Colors.loginGradientStart
                    ],
                    begin: const FractionalOffset(0.2, 0.2),
                    end: const FractionalOffset(1.0, 1.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  ),
                ),
                child: MaterialButton(
                  highlightColor: Colors.transparent,
                  splashColor: Theme.Colors.loginGradientEnd,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
                    child: Text(
                      "LOGIN",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontFamily: "WorkSansBold",
                      ),
                    ),
                  ),
                  onPressed: () => _authenticateUser(model),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: FlatButton(
                onPressed: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (_) => PasswordResetRequest(),
                  );

//                  showDialog(
//                    context: context,
//                    builder: (_) => AlertDialog(
//                      title: Text('Forgot Password'),
//                      content: Text(
//                          'Please visit ACSS section in Computer Department to confirm your identity and get your password changed.'),
//                    ),
//                  );
                },
                child: Text(
                  "Forgot Password",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.white,
                    fontSize: 16.0,
                    fontFamily: "WorkSansMedium",
                  ),
                )),
          ),
        ],
      ),
    );
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
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

  _sendOTPRequest() async {
    if (_formKey.currentState.validate()) {
      FocusScope.of(context).requestFocus(new FocusNode());
      try {
        dynamic token = await NetworkUtils.post('/api/password/reset', {
          'email': _emailController.text,
        });

        setState(() {
          _emailError =
              token['errors'] != null ? token['errors']['email'][0] : null;
        });
        if (token['token'] != null)
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => PasswordReset(token['token']),
          ));
        return;
      } catch (e) {
        print('password_change _sendOTPRequest $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(16.0),
      titlePadding: EdgeInsets.all(16.0),
      elevation: 5.0,
      content: Wrap(
        children: <Widget>[
          Text(
            'Forgot Password',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          Divider(
            color: Colors.black54,
            height: 20,
          ),
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                  labelText: "Enter registered email", errorText: _emailError),
              keyboardType: TextInputType.emailAddress,
              inputFormatters: [BlacklistingTextInputFormatter(RegExp(" "))],
              validator: (value) {
                if (value.isEmpty) return 'Please enter email address';
                Pattern pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regex = new RegExp(pattern);
                if (!regex.hasMatch(value)) return 'Enter valid email address';
                return null;
              },
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          textColor: Colors.redAccent,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Close'),
        ),
        RaisedButton(
          color: Colors.blueAccent,
          textColor: Colors.white,
          onPressed: () {
            _sendOTPRequest();
          },
          child: Text('Send OTP'),
        )
      ],
    );
  }
}
