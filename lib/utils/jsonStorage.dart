import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class JsonStorage {
  Directory _dir;

  String _filename = 'braodcast_temp';

  bool _fileExists = false;

  JsonStorage();

  dynamic _getPath() async {
    try {
      _dir = await getTemporaryDirectory();
    } catch (e) {
      print('jsonstorage _getpath Error $e');
    }
  }

  dynamic writeJson() async {
    if (_dir == null) await _getPath();
    var _jsonFile = File(_dir.path + '/$_filename.broadcast');
    _fileExists = _jsonFile.existsSync();
    if (_fileExists) {
      Map<String, dynamic> data = json.decode(_jsonFile.readAsStringSync());
      Map<String, dynamic> content = {'jhsajad': 'sadjasgdaksjkd'};
      data.addAll(content);

      _jsonFile.writeAsStringSync(json.encode(data));
    } else
      _jsonFile = _createJsonFile();
    return _jsonFile;
  }

  dynamic _createJsonFile() async {
    if (_dir == null) await _getPath();
    var _jsonFile = File(_dir.path + '/$_filename.broadcast');
    _jsonFile.createSync();
    _jsonFile.writeAsStringSync(
      jsonEncode({'name': 'divyanhsu', 'email': 'creating@gmail.com'}),
    );
    return _jsonFile;
  }
}
