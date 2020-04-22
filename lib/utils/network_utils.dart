import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'auth_utils.dart';

class NetworkUtils {
  static final String host = productionHost;

  static final String productionHost = 'http://192.168.43.83:8000';
  static final String developmentHost = 'http://192.168.43.83:8000';

//
//  static final String productionHost = 'https://slietbroadcast.in';
//  static final String developmentHost = 'https://slietbroadcast.in';

  static Future<SharedPreferences> _shPrefs = SharedPreferences.getInstance();

  static dynamic authenticateUser(String email, String password) async {
    var uri = host + AuthUtils.endPoint;

    try {
      final response =
          await http.post(uri, body: {'username': email, 'password': password});

      final responseJson = json.decode(response.body);
      if (response.statusCode == 206) return {'newUser': responseJson};
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

  static logoutUser(BuildContext context, SharedPreferences prefs) async {
    await logout(prefs: prefs);

//    Navigator.of(context).pushReplacementNamed('/');
//    showSnackBar(context, message)
    Navigator.pushNamedAndRemoveUntil(context, "/start", (r) => false);
//    Navigator.of(context).push(
//      MaterialPageRoute(
//        builder: (BuildContext context) => HomePage(),
//      ),
//    );
  }

  static logout({SharedPreferences prefs}) async {
    if (prefs is SharedPreferences) _logout(prefs);
    _logout(await getSharedPreference());
  }

  static _logout(SharedPreferences prefs) {
    prefs.setString(AuthUtils.authTokenKey, null);
    prefs.setInt(AuthUtils.userIdKey, null);
    prefs.setString(AuthUtils.nameKey, null);
    prefs.setString(AuthUtils.username, 'STUDENT');
    prefs.setString(AuthUtils.userType, null);
    prefs.setBool('isAdmin', false);
    prefs.setString('profile', null);
  }

//  static showSnackBar(GlobalKey<ScaffoldState> scaffoldKey, String message) {
//    scaffoldKey.currentState.showSnackBar(new SnackBar(
//      content: new Text(message ?? 'You are offline'),
//    ));
//  }

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
      print("network_utils fetch $exception");
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static get(var endPoint) async {
    var prefs = await SharedPreferences.getInstance();
    var uri = host + endPoint;
    String token = prefs.getString(AuthUtils.authTokenKey);
    try {
      final response = await http.get(
        uri,
        headers: {'Authorization': token != null ? "Token " + token : ""},
      );
      if (response.statusCode == 401) {
        await logout(prefs: prefs);
        throw Error();
      }
      final responseJson = json.decode(response.body);
      return responseJson;
    } catch (exception) {
      if (exception.toString().contains('SocketException')) {
        return null;
      } else {
        return null;
      }
    }
  }

  static dynamic post(var endPoint, Object data) async {
    var prefs = await SharedPreferences.getInstance();
    var uri = host + endPoint;
    dynamic token = prefs.getString(AuthUtils.authTokenKey);
    try {
      final response = await http.post(
        uri,
        body: data,
        headers: {
          'Authorization': token == null ? "" : 'Token ' + token.toString()
        },
      );

      final responseJson = json.decode(response.body);
      if (response.statusCode == 400) return {'errors': responseJson};
      return responseJson;
    } catch (exception) {
      print('network_utils static post $exception');
//      print(exception);
//      if (exception.toString().contains('SocketException')) {
//        return 'NetworkError';
//      } else {
//        return null;
//      }
    }
  }

  static dynamic delete(var endPoint) async {
    var prefs = await SharedPreferences.getInstance();
    var uri = host + endPoint;
    try {
      final response = await http.delete(
        uri,
        headers: {
          'Authorization': 'Token ' + prefs.getString(AuthUtils.authTokenKey)
        },
      );
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

  static getSharedPreference() async {
    SharedPreferences _sharedPreferences;
    _sharedPreferences = await _shPrefs;
    return _sharedPreferences;
  }

  static dynamic postForm(var endPoint, File _image) async {
    String apiUrl = host + endPoint;
    final length = await _image.length();
    final request = new http.MultipartRequest('POST', Uri.parse(apiUrl))
      ..files.add(new http.MultipartFile('avatar', _image.openRead(), length));
    http.Response response =
        await http.Response.fromStream(await request.send());
//    print("Result: ${response.body}");
    return json.decode(response.body);
  }

//  static getSharedPreference() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    return prefs;
//  }

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
      return (token != null);
    } catch (onError) {
      return false;
    }
  }

  Future<String> getUserType() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      String userType = prefs.getString(AuthUtils.userType);
      return userType;
    } catch (onError) {
      return "STUDENT";
    }
  }

  static Future fetchData(String url) async {
    Dio dio = new Dio();
    Response response;
    try {
      var token = await getTokenStatic();
      if (token != null)
        dio.options.headers['Authorization'] = "Token " + token;
    } catch (e) {
      print('network_utils fetchData Error $e');
    }

    try {
      response = await dio.get('$host/api$url');
      if (response.statusCode == 401) await logout();
      if (response.statusCode != 200) {
        print('network_utils fetch data Error ${response.statusCode}: $url');
        throw HttpException(
          'Invalid response ${response.statusCode}',
          uri: Uri.parse(url),
        );
      }
      return response;
    } on DioError catch (error) {
      if (error.response != null && error.response.statusCode == 401) {
        await logout();
      }
      response = error.response;
      return response;
    } catch (e) {
      print('network_utils fetchData catch Error $e');
    }
  }
}
