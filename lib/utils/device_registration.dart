import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sliet_broadcast/utils/network_utils.dart';

class DeviceRegistration {
  static final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  static final DeviceInfoPlugin _deviceInfoPlugin = new DeviceInfoPlugin();
  static final Dio _dio = new Dio(); // creating instance of dio networking
  static String _token;

  static register({FirebaseMessaging fireBaseMessaging}) async {
    _token = await NetworkUtils.getTokenStatic();
    if (_token == null) return null;
    if (fireBaseMessaging is FirebaseMessaging)
      return await _verifyDevice(fireBaseMessaging);
    return await _verifyDevice(_firebaseMessaging);
  }

  static _verifyDevice(FirebaseMessaging fireBase) async {
    if (_token != null) {
      _dio.options.headers['Authorization'] = "Token " + _token;
      String _deviceToken = await fireBase.getToken();
      try {
        Response response = await _dio.get(
          NetworkUtils.host + '/devices/$_deviceToken',
        );
        if (response.statusCode == 200) {
          if (response.data['active'] == false) return _updateDevice(fireBase);
        }
      } on DioError catch (e) {
        if (e.response.statusCode == 401) NetworkUtils.logout();
        if (e.response.statusCode == 404) await _registerDevice(fireBase);
        print('device_registration _verifyDevice onDioError Error $e');
      } catch (e) {}
    }
    fireBase.onTokenRefresh.listen((token) {
      print("device_registration _verifyDevice on_token_refresh");
    });
  }

  static _registerDevice(FirebaseMessaging fireBase) async {
    FormData formData = await _formData(fireBase);
    if (formData == null || _token == null) return;
    _dio.options.headers['Authorization'] = "Token " + _token;
    try {
      await _dio.post(
        NetworkUtils.host + '/devices/',
        data: formData,
      );
    } on DioError catch (e) {
      if (e.response.statusCode == 401) NetworkUtils.logout();
      print('device_registration _registerDevice onDioError Error $e');
    } catch (e) {}
  }

  static _updateDevice(FirebaseMessaging fireBase) async {
    String _deviceToken = await fireBase.getToken();
    FormData formData = await _formData(fireBase);
    if (formData == null || _token == null) return;
    _dio.options.headers['Authorization'] = "Token " + _token;
    try {
      await _dio.patch(
        NetworkUtils.host + '/devices/$_deviceToken/',
        data: formData,
      );
    } on DioError catch (e) {
      if (e.response.statusCode == 401) NetworkUtils.logout();
      print('device_registration _updateDevice onDioError Error $e');
    } catch (e) {}
  }

  static _formData(FirebaseMessaging fireBase) async {
    String _deviceToken = await fireBase.getToken();
    FormData formData = new FormData();
    if (Platform.isIOS) {
      IosDeviceInfo androidInfo = await _deviceInfoPlugin.iosInfo;
      formData.addAll({
        "name": androidInfo.name,
        "registration_id": _deviceToken,
        "device_id": androidInfo.utsname.toString(),
        "active": true,
        "type": 'ios'
      });
      return formData;
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await _deviceInfoPlugin.androidInfo;
      formData.addAll({
        "name": androidInfo.model.toString(),
        "registration_id": _deviceToken,
        "device_id": androidInfo.androidId,
        "active": true,
        "type": 'android'
      });
      return formData;
    } else {
      return formData;
    }
  }
}
