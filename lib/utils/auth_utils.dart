import 'package:shared_preferences/shared_preferences.dart';

class AuthUtils {
  static final String endPoint = '/api/auth/login';

  // Keys to store and fetch data from SharedPreferences
  static final String authTokenKey = 'auth_token';
  static final String userIdKey = 'user_id';
  static final String nameKey = 'name';
  static final String roleKey = 'role';
  static final String username = 'username';
  static final String userType = 'user_type';
  static final bool isAdmin = false;

  static String getToken(SharedPreferences prefs) {
    return prefs.getString(authTokenKey);
  }
  static bool isAuthenticated(SharedPreferences prefs) {
    return (prefs.getString(authTokenKey) != null);
  }

  static insertDetails(SharedPreferences prefs, var response) {
    print(response);
    prefs.setString(authTokenKey, response['token']);
    prefs.setString(userIdKey, response['id']);
    prefs.setString(nameKey, response['name']);
    prefs.setString(username, response['username']);
    prefs.setString(userType, response['user_type']);
    prefs.setBool('isAdmin', response['is_Admin']);
  }
}
