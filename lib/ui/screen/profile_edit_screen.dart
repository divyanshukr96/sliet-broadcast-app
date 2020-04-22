import 'dart:io';
import 'package:cache_image/cache_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sliet_broadcast/core/constant.dart';
import 'package:sliet_broadcast/core/models/user.dart';
import 'package:sliet_broadcast/core/viewmodels/views/user_profile_model.dart';
import 'package:sliet_broadcast/style/theme.dart' as Theme;
import 'package:sliet_broadcast/views/base_widget.dart';

class ProfileEditScreen extends StatefulWidget {
  final User profile;

  ProfileEditScreen(this.profile);

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
    super.initState();
    _aboutController.text = widget.profile.about;
    _mobileController.text = widget.profile.mobile;
    _profile = widget.profile.profile;
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider profileUrl = AssetImage('assets/images/login.png');
    if (_profile != null) {
      profileUrl = CacheImage(_profile);
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("Edit Profile")),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.blueAccent,
        child: SingleChildScrollView(
          child: BaseWidget(
            model: UserProfileModel(
              authenticationService: Provider.of(context),
            ),
            builder: (context, UserProfileModel model, _) {
              return Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 16.0, bottom: 8.0),
                    width: 120.0,
                    height: 120.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: _image == null
                            ? profileUrl
                            : Image.file(_image).image,
                      ),
                      borderRadius: BorderRadius.circular(75.0),
                      border: Border.all(color: Colors.white, width: 2.0),
                    ),
                  ),
                  MaterialButton(
                    highlightColor: Colors.transparent,
                    splashColor: Theme.Colors.loginGradientEnd,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 42.0,
                      ),
                      child: Text(
                        "Choose profile photo",
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                    ),
                    onPressed: getImage,
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
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
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: "About",
                          hintStyle: TextStyle(fontSize: 17.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.lightBlueAccent,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
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
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        inputFormatters: [
                          BlacklistingTextInputFormatter(RegExp(" ")),
                          WhitelistingTextInputFormatter.digitsOnly,
                        ],
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: "Contact Number",
                          hintStyle: TextStyle(fontSize: 17.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.lightBlueAccent,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 12.0, bottom: 30.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      gradient: LoginLinearGradient(),
                    ),
                    child: MaterialButton(
                      highlightColor: Colors.transparent,
                      splashColor: Theme.Colors.loginGradientEnd,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 24.0,
                        ),
                        child: Text(
                          "Update Profile",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        await _updateProfile(model);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  _updateProfile(UserProfileModel model) async {
    FormData formData = new FormData();
    var data = {};
    if (_aboutController.text != widget.profile.about) {
      formData.add('about', _aboutController.text);
      data['about'] = _aboutController.text;
    }
    if (_mobileController.text != widget.profile.mobile) {
      formData.add('mobile', _mobileController.text);
      data['mobile'] = _mobileController.text;
    }
    if (_image != null) {
      String fileName = _image.path.split("/").last;
      data['profile'] = fileName;
      formData.add('profile', new UploadFileInfo(_image, fileName));
    }
    if (data.isEmpty) return;

    try {
      await model.updateUserProfile(data: formData);
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'Profile successfully updated ...',
          style: TextStyle(color: Colors.white70, fontSize: 18.0),
        ),
        backgroundColor: Colors.green,
      ));
      Navigator.pop(context);
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response.data != null)
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(
              'Incorrect data entered!',
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
