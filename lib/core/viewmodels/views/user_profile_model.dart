import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:sliet_broadcast/core/models/user.dart';
import 'package:sliet_broadcast/core/services/authenticationService.dart';
import 'package:sliet_broadcast/core/viewmodels/base_model.dart';

class UserProfileModel extends BaseModel {
  AuthenticationService _authenticationService;

  UserProfileModel({
    @required AuthenticationService authenticationService,
  }) : _authenticationService = authenticationService;

  Stream<User> get user => _authenticationService.user;

  void getUser() async {
    setBusy();
    await _authenticationService.getUser();
    setBusy(value: false);
  }

  updateUserProfile({FormData data}) async {
    await _authenticationService.updateUser(data: data);
  }
}
