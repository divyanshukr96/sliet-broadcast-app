import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliet_broadcast/core/models/user.dart';

class Api {
//  static const endpoint = 'http://192.168.43.239:8000/api';
  static const endpoint = 'http://192.168.43.83:8000/api';

//  static const endpoint = 'https://slietbroadcast.in/api';

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _preferences;
  Dio client = Dio()
    ..interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options) {
//        options.cancelToken
        return options;
      },
      onResponse: (Response response) {
        return response;
      },
      onError: (DioError error) {
//        if(error.response?.statusCode == 401){
//          _setToken();
//        }
        return error;
      },
    ));

  Api() {
    _prefs.then((SharedPreferences preferences) {
      _preferences = preferences;
    }, onError: (err) => print('$err'));
  }

  Future<User> getLocalUser() async {
    String _user = _preferences.getString('authUser');
    if (_user == null) throw ErrorDescription('local authUser not found');
    User user = User.fromJson(jsonDecode(_user));
    _setToken(token: user.token);
    return user;
  }

  Future<void> updateLocalUser({User user}) async {
    User _usr = await getLocalUser();
    user.token = _usr.token;
    await _preferences.setString('authUser', jsonEncode(user.toJson()));
  }

//  Future<User> getUserProfile(int userId) async {
//    // Get user profile for id
//    Response response = await client.get('$endpoint/users/$userId');
//
//    // Convert and return
//    return User.fromJson(response.data);
//  }

  Future<User> login(String username, String password) async {
    try {
      Response response = await client.post('$endpoint/auth/login', data: {
        'username': username,
        'password': password,
      });
      if (response.statusCode == 200) {
        _preferences.setString('authUser', jsonEncode(response.data));
        _setToken(token: response.data['token']);
      }
      // Convert and return
      return User.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  // TODO token check on logout action
  Future<bool> logout() async {
    await client.post('$endpoint/auth/logout');
    _preferences.remove('authUser');
    _setToken();
    return true;
  }

  Future<Response> getNotice() async {
    try {
      Response response = await client.post('$endpoint/public/notice');
      return response;
    } catch (e) {
      throw e;
    }
  }

  _setToken({String token}) {
    String _token = "";
    if (token != null && token.isNotEmpty) {
      _token = "Token " + token;
    }
    client.options.headers['Authorization'] = _token;
  }

  Future<Response> get({String path = "", Map<String, dynamic> query}) async {
    return await client.get('$endpoint$path', queryParameters: query);
  }

  Future<Response> post({String path = "", data, Options options}) async {
    return await client.post('$endpoint$path', data: data, options: options);
  }

  Future<Response> patch({String path = "", data, Options options}) async {
    return await client.patch('$endpoint$path', data: data, options: options);
  }

  Future<Response> delete({String path}) async {
    return await client.delete('$endpoint$path');
  }

  Future<void> changePassword(String password, String newPassword) async {
    String _url = '$endpoint/auth/user/password';
    Response response = await client.post(
      _url,
      data: {"password": password, "new_password": newPassword},
    );
    _setToken(token: response.data['token']);

    try {
      User user = await getLocalUser();
      user.token = response.data['token'];
      _preferences.setString('authUser', jsonEncode(user.toJson()));
    } catch (err) {
      print('Api changePassword Error : $err');
    }
  }
}
