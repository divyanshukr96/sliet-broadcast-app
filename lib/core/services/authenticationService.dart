import 'dart:async';
import 'package:dio/dio.dart';
import 'package:sliet_broadcast/core/models/user.dart';
import 'package:sliet_broadcast/core/services/api.dart';

class AuthenticationService {
  final Api _api;

  AuthenticationService({Api api}) : _api = api;

  StreamController<User> _userController = StreamController<User>.broadcast();

  Stream<User> get user => _userController.stream;

  Future<User> login(String username, String password) async {
    try {
      User _user = await _api.login(username, password);
      if (!_user.newUser) _userController.add(_user);
      return _user;
    } catch (err) {
      throw err;
    }
  }

  Future<void> getUser() async {
    try {
      User _user = await _api.getLocalUser();
      _userController.add(_user);
    } catch (err) {
      print('AuthenticationService getUser $err');
    }
  }

  Future<void> logout() async {
    await _api.logout();
    _userController.add(User());
  }

  Future<void> updateUser({data}) async {
    Response response = await _api.patch(
      path: '/auth/user/update',
      data: data,
      options: RequestOptions(
        headers: {
          "content-type": "application/x-www-form-urlencoded",
        },
      ),
    );
    User user = User.fromJson(response.data);
    await _api.updateLocalUser(user: user);
    _userController.add(user);
  }
}
