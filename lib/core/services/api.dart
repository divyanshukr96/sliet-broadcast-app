import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliet_broadcast/components/models/user.dart';
import 'package:sliet_broadcast/utils/auth_utils.dart';

class Api {
  static const endpoint = 'http://192.168.137.1:8000/api';

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Dio client = new Dio();

  Future<User> getUserProfile(int userId) async {
    // Get user profile for id
    Response response = await client.get('$endpoint/users/$userId');

    // Convert and return
    return User.fromJson(response.data);
  }

  Future<Response> login(String username, String password) async {
    try {
      Response response = await client.post('$endpoint/auth/login', data: {
        'username': username,
        'password': password,
      });
      if (response.statusCode == 200) {
        User.fromJson(response.data);
        AuthUtils.insertDetails(await _prefs, response.data);
      }
      // Convert and return
      return response;
    } catch (e) {
      throw e;
    }
  }
}
