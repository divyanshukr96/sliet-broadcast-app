import 'dart:async';

import 'package:dio/dio.dart';
import 'package:sliet_broadcast/core/services/api.dart';

class AuthenticationService {
  final Api _api;

  AuthenticationService({Api api}) : _api = api;

//  StreamController<User> _userController = StreamController<User>();

//  Stream<User> get user => _userController.stream;

  Future<Response> login(String username, String password) async {
    return await _api.login(username, password);
  }
}
