import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:sliet_broadcast/core/models/department.dart';
import 'package:sliet_broadcast/core/models/register.dart';
import 'package:sliet_broadcast/core/services/api.dart';
import 'package:sliet_broadcast/core/viewmodels/base_model.dart';

class RegisterModel extends BaseModel {
  Api _api;

  List<Department> _departments = new List<Department>();
  List<dynamic> _programs = new List();

  RegisterModel({
    @required Api api,
  }) : _api = api;

  List<Department> get departments => _departments;

  List<dynamic> get programs => _programs;

  Future<dynamic> register(Register student) async {
    setBusy();
    try {
      Response response = await _api.post(
        path: '/auth/register',
        data: student.toJson(),
      );
      setBusy(value: false);
      return response;
    } catch (err) {
      setBusy(value: false);
      throw err;
    }
  }

  Future<dynamic> registerFaculty(Register faculty) async {
    setBusy();
    try {
      Response response = await _api.post(
        path: '/auth/register/faculty',
        data: faculty.toJson(),
      );
      setBusy(value: false);
      return response;
    } catch (err) {
      setBusy(value: false);
      throw err;
    }
  }

  void initialize() async {
    setBusy();
    _departments = await _getDepartments();
    setBusy();
    _programs = await _getProgram();
    setBusy(value: false);
  }

  void getUser() async {
    setBusy();
//    await _authenticationService.getUser();
    setBusy(value: false);
  }

  Future<List<Department>> _getDepartments() async {
    try {
      Response response = await _api.get(path: '/departments');
      return List<Department>.from(
        response.data.map((dept) => Department.fromJson(dept)),
      );
    } catch (err) {
      return List<Department>();
    }
  }

  Future<dynamic> _getProgram() async {
    try {
      Response response = await _api.get(path: '/programs');
      return response.data;
    } catch (err) {
      return List();
    }
  }
}
