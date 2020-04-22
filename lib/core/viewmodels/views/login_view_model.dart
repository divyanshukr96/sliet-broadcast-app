import 'package:flutter/widgets.dart';
import 'package:sliet_broadcast/core/models/user.dart';
import 'package:sliet_broadcast/core/services/authenticationService.dart';
import 'package:sliet_broadcast/core/viewmodels/base_model.dart';

class LoginViewModel extends BaseModel {
  AuthenticationService _authenticationService;

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  LoginViewModel({
    @required AuthenticationService authenticationService,
  }) : _authenticationService = authenticationService;

  Future<dynamic> login() async {
    setBusy();
    try {
      String username = emailController.text;
      String password = passwordController.text;
      User response = await _authenticationService.login(username, password);
      setBusy(value: false);
      return response;
    } catch (err) {
      setBusy(value: false);
      throw err;
    }
  }

  void getUser() async {
    setBusy();
    await _authenticationService.getUser();
    setBusy(value: false);
  }
}
