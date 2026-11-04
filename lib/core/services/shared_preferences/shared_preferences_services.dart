import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static SharedPreferencesService? _instance;
  static SharedPreferences? _prefs;

  SharedPreferencesService._internal();

  static Future<SharedPreferencesService> getInstance() async {
    if (_instance == null) {
      _instance = SharedPreferencesService._internal();
      _prefs = await SharedPreferences.getInstance();
    }

    return _instance!;
  }

  Future<bool> setString(String key, String value) async {
    return await _prefs!.setString(key, value);
  }

  String? getString(String key) {
    return _prefs!.getString(key);
  }

  List<String>? getStringList(String key) {
    return _prefs!.getStringList(key);
  }

  Future<bool>? setStringList(String key, List<String> value) {
    return _prefs!.setStringList(key, value);
  }

  Future<bool> setBool(String key, bool value) async {
    return await _prefs!.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs!.getBool(key);
  }

  Future<bool> remove(String key) async {
    return await _prefs!.remove(key);
  }
}
