import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:sliet_broadcast/core/services/api.dart';
import 'package:sliet_broadcast/core/viewmodels/base_model.dart';

class PasswordResetModal extends BaseModel {
  Api _api;

  PasswordResetModal({
    @required Api api,
  }) : _api = api;

  String get endPoint => Api.endpoint;

  Future<String> requestOtp({String email}) async {
    setBusy();
    try {
      Response response = await _api.post(
        path: '/password/reset',
        data: {"email": email},
      );
      setBusy(value: false);
      return response.data['token'];
    } catch (err) {
      setBusy(value: false);
      throw err;
    }
  }

  Future<String> confirmOtp({String token, String otp}) async {
    setBusy();
    try {
      Response response = await _api.post(
        path: '/password/reset/confirm',
        data: {"token": token, "otp": otp},
      );
      setBusy(value: false);
      return response.data['token'];
    } catch (err) {
      setBusy(value: false);
      throw err;
    }
  }

  Future<void> changePassword({String password, String newPassword}) async {
    setBusy();
    await _api.changePassword(password, newPassword);
    setBusy(value: false);
  }
}
