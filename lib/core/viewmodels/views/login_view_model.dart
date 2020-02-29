import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:sliet_broadcast/core/services/authenticationService.dart';
import 'package:sliet_broadcast/core/viewmodels/base_model.dart';

class LoginViewModel extends BaseModel {
  AuthenticationService _authenticationService;

  LoginViewModel({
    @required AuthenticationService authenticationService,
  }) : _authenticationService = authenticationService;

  Future<dynamic> login(
      TextEditingController username, TextEditingController password) async {
    setBusy(true);
    Response response =
        await _authenticationService.login(username.text, password.text);
    if (response.statusCode == 206) return {'newUser': response.data};
    setBusy(false);
    return response.data;
  }
}
