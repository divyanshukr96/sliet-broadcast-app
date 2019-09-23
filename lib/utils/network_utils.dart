import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sliet_broadcast/homepage.dart';
import 'auth_utils.dart';

class NetworkUtils {
  static final String host = productionHost;
  static final String productionHost = 'http://192.168.137.1:8000';
  static final String developmentHost = 'http://192.168.137.1:8000';

  static dynamic authenticateUser(String email, String password) async {
    var uri = host + AuthUtils.endPoint;

    try {
      final response =
          await http.post(uri, body: {'username': email, 'password': password});

      final responseJson = json.decode(response.body);
      if (response.statusCode == 400) return {'errors': responseJson};
      return responseJson;
    } catch (exception) {
//      print(exception);
//      if (exception.toString().contains('SocketException')) {
//        return 'NetworkError';
//      } else {
//        return null;
//      }
    }
  }

  static logoutUser(BuildContext context, SharedPreferences prefs) {
    prefs.setString(AuthUtils.authTokenKey, null);
    prefs.setInt(AuthUtils.userIdKey, null);
    prefs.setString(AuthUtils.nameKey, null);
    prefs.setString(AuthUtils.username, null);
    prefs.setString(AuthUtils.userType, null);
    prefs.setBool('isAdmin', false);
    print(prefs.getString(AuthUtils.authTokenKey));

//    Navigator.of(context).pushReplacementNamed('/');
//    showSnackBar(context, message)
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => HomePage(),
      ),
    );
  }

  static showSnackBar(GlobalKey<ScaffoldState> scaffoldKey, String message) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(message ?? 'You are offline'),
    ));
  }

  static fetch(var authToken, var endPoint) async {
    var uri = host + endPoint;

    try {
      final response = await http.get(
        uri,
        headers: {'Authorization': authToken},
      );

      final responseJson = json.decode(response.body);
      return responseJson;
    } catch (exception) {
      print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static get(var authToken, var endPoint) async {
    var prefs = getSharedPreference();

    print(prefs.getString(AuthUtils.authTokenKey));

    var uri = host + endPoint;

    try {
      final response = await http.get(
        uri,
        headers: {'Authorization': authToken},
      );

      final responseJson = json.decode(response.body);
      return responseJson;
    } catch (exception) {
      print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static getSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  static Future<String> getTokenStatic() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return AuthUtils.getToken(prefs);
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return AuthUtils.getToken(prefs);
  }

  Future<bool> isAuthenticated() async {
    try {
      String token = await getToken();
      print(token.toString() + "  is_authenticated    network_utild.dart");
      return (token != null);
    } catch (onError) {
      return false;
    }
  }
}
