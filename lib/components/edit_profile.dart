import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:image_picker_modern/image_picker_modern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliet_broadcast/components/profile.dart';
import 'package:sliet_broadcast/style/theme.dart' as Theme;
import 'package:sliet_broadcast/utils/network_utils.dart';

class EditProfile extends StatefulWidget {
  final profile;

  EditProfile(this.profile);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  NetworkUtils networkUtils = new NetworkUtils();
  Response response;
  Dio dio = new Dio();
  final _aboutController = new TextEditingController();
  final _mobileController = new TextEditingController();

  var _profile;
  var _image;

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  void initState() {
    _aboutController.text = widget.profile['about'];
    _mobileController.text = widget.profile['mobile'];
    setState(() {
      _profile = widget.profile['profile'];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    ImageProvider profileUrl = AssetImage('assets/images/login.png');
    if (_profile != null) {
      profileUrl = NetworkImage(_profile);
    }


    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Edit Profile"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.blueAccent,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 16.0, bottom: 8.0),
                width: 150.0,
                height: 150.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: _image == null
                        ? profileUrl
                        : Image.file(_image).image,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(75.0),
                  border: Border.all(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
              ),
              MaterialButton(
                highlightColor: Colors.transparent,
                splashColor: Theme.Colors.loginGradientEnd,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 42.0),
                  child: Text(
                    "Choose profile photo",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontFamily: "WorkSansBold"),
                  ),
                ),
                onPressed: getImage,
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _aboutController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    maxLength: 1000,
                    style: TextStyle(
                        fontFamily: "WorkSansSemiBold",
                        fontSize: 16.0,
                        color: Colors.black),
                    decoration: InputDecoration(
                      labelText: "About",
                      hintStyle: TextStyle(
                          fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.lightBlueAccent, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                      ),
                    ),
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _mobileController,
                    keyboardType: TextInputType.multiline,
                    maxLength: 11,
                    style: TextStyle(
                        fontFamily: "WorkSansSemiBold",
                        fontSize: 16.0,
                        color: Colors.black),
                    decoration: InputDecoration(
                      labelText: "Contact Number",
                      hintStyle: TextStyle(
                          fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.lightBlueAccent, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 12.0, bottom: 30.0),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  gradient: new LinearGradient(
                      colors: [
                        Theme.Colors.loginGradientEnd,
                        Theme.Colors.loginGradientStart
                      ],
                      begin: const FractionalOffset(0.2, 0.2),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: MaterialButton(
                    highlightColor: Colors.transparent,
                    splashColor: Theme.Colors.loginGradientEnd,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 42.0),
                      child: Text(
                        "Update Profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontFamily: "WorkSansBold",
                        ),
                      ),
                    ),
                    onPressed: _updateProfile),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _updateProfile() async {
    FormData formData = new FormData();
    var data = {};
    if (_aboutController.text != widget.profile['about']) {
      formData.add('about', _aboutController.text);
      data['about'] = _aboutController.text;
    }
    if (_mobileController.text != widget.profile['mobile']) {
      formData.add('mobile', _mobileController.text);
      data['mobile'] = _mobileController.text;
    }
    if (_image != null) {
      String fileName = _image.path.split("/").last;
      data['profile'] = fileName;
      formData.add('profile', new UploadFileInfo(_image, fileName));
    }
    if (data.isEmpty) return;

    String token = await networkUtils.getToken();

    try {
      dio.options.headers['Authorization'] = "Token " + token;
      dio.options.headers['content-type'] = "application/x-www-form-urlencoded";
      dio.options.headers['Accept'] = "application/json";
      response = await dio.patch(
        NetworkUtils.productionHost + "/api/auth/user/update",
        data: formData,
      );
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            'Profile successfully updated ...',
            style: TextStyle(color: Colors.white70, fontSize: 18.0),
          ),
          backgroundColor: Colors.green,
        ));
        prefs.setString('profile', jsonEncode(response.data));

        Navigator.pop(context);
        Navigator.popAndPushNamed(context, '/profile');
//        Navigator.pop(context);
//        Navigator.pop(context);
//        Navigator.pop(context);
//        Navigator.push(
//          context,
//          MaterialPageRoute(
//            builder: (BuildContext context) => Profile(),
//          ),
//        );
      }
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response.data != null)
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(
              'Incorrect input entered!',
              style: TextStyle(color: Colors.white70),
            ),
            backgroundColor: Colors.deepOrange,
          ));
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Something went wrong!'),
        ));
      }
    }
  }
}
