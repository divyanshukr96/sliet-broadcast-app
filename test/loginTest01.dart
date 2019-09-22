import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

    final emailField = TextFormField(
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          hintText: "Email / Username",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 16.0),
          icon: Icon(Icons.person)),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please enter your Email / username.';
        } else if (value.length < 5) {
          return 'Username must be more than 5 character.';
        } else
          return null;
      },
      autovalidate: _autoValidate,
      autocorrect: true,
    );

    final passwordField = TextFormField(
      obscureText: true,
      style: style,
      decoration: InputDecoration(
        hintText: "Password",
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter you password.';
        }
        return null;
      },
      autovalidate: _autoValidate,
    );

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(4.0),
      color: Colors.blue.shade700,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width / 2.5,
        padding: EdgeInsets.all(2.0),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            setState(() {
              _autoValidate = false;
            });
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: Text('Login Processing . . .'),
                backgroundColor: Colors.green,
              ),
            );
          } else
            setState(() {
              _autoValidate = true;
            });
        },
        child: Text(
          'Login',
          textAlign: TextAlign.center,
          style: style.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: _scaffoldKey,
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 40.0, bottom: 40.0),
                        child: Text(
                          "SLIET Broadcast",
                          style: TextStyle(fontSize: 24.0),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 45.0),
                  emailField,
                  SizedBox(height: 25.0),
                  passwordField,
                  SizedBox(height: 35.0),
                  loginButton,
                  SizedBox(height: 15.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
