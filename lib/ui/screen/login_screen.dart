import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sliet_broadcast/core/constant.dart';
import 'package:sliet_broadcast/ui/screen/faculty_register_screen.dart';
import 'package:sliet_broadcast/core/models/user.dart';
import 'package:sliet_broadcast/ui/widgets/password_reset.dart';
import 'package:sliet_broadcast/core/viewmodels/views/login_view_model.dart';
import 'package:sliet_broadcast/ui/widgets/login/login_button.dart';
import 'package:sliet_broadcast/ui/widgets/login/login_title.dart';
import 'package:sliet_broadcast/ui/widgets/snackbar_view.dart';
import 'package:sliet_broadcast/views/base_widget.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _obscureTextLogin = false;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      model: LoginViewModel(authenticationService: Provider.of(context)),
      builder: (context, model, child) {
        return Scaffold(
          key: _scaffoldKey,
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overScroll) {
                  overScroll.disallowGlow();
                  return null;
                },
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        gradient: LoginLinearGradient(),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 40.0),
                            child: Image(
                              width: 80.0,
                              height: 80.0,
                              fit: BoxFit.fill,
                              image: AssetImage('assets/images/login.png'),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0, bottom: 23.0),
                            child: LoginTitle(),
                          ),
                          buildLoginFormCard(context, model),
                        ],
                      ),
                    ),
                    NewAccountButton(),
                    LoginBackButton(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Card buildLoginFormCard(BuildContext context, model) {
    TextStyle _textStyle = TextStyle(
      fontSize: 16.0,
      color: Colors.black,
    );
    TextStyle _hintStyle = TextStyle(
      fontSize: 17.0,
    );

    return Card(
      elevation: 2.0,
      child: Container(
        margin: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Email / Username',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  TextField(
                    controller: model.emailController,
                    keyboardType: TextInputType.emailAddress,
                    inputFormatters: [
                      BlacklistingTextInputFormatter(RegExp(" "))
                    ],
                    style: _textStyle,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Color(0xfff3f3f4),
                      filled: true,
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: Colors.black54,
                      ),
                      hintText: "Email / Username",
                      hintStyle: _hintStyle,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Password',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  TextField(
                    enableInteractiveSelection: false,
                    controller: model.passwordController,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: !_obscureTextLogin,
                    inputFormatters: [
                      BlacklistingTextInputFormatter(RegExp(" "))
                    ],
                    style: _textStyle,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Color(0xfff3f3f4),
                      filled: true,
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Colors.black54,
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
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(8),
              child: RaisedButton(
                onPressed: () => _authenticateUser(model),
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.shade200,
                        offset: Offset(2, 4),
                        blurRadius: 5,
                        spreadRadius: 2,
                      )
                    ],
                    gradient: LoginLinearGradient(),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 36,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    alignment: Alignment.center,
                    child: Text(
                      'Login ${model.busy ? '...' : ''}',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 8),
              padding: EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.centerRight,
              child: InkWell(
                child: Text(
                  'Forgot Password ?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => PasswordResetRequest(),
                  );
//                  _scaffoldKey.currentState.showBottomSheet((builder) {
//                    return PasswordResetRequest();
//                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
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
    if (!model.busy) {
      try {
        User user = await model.login();
        if (user.newUser) {
          return Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => FacultyRegister(
                faculty: user.details,
              ),
            ),
          );
        } else {
          Navigator.pop(context);
        }
      } catch (e) {
        String _err = "Invalid Email/Password";
        if (e.response != null && e.response.data != null) {
          _err = e.response.data['username'][0];
        }
        SnackBarView.show(_scaffoldKey, _err);
      }
    }
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }
}
