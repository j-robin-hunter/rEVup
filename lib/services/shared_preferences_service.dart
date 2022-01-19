import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {

  dynamic get(String key) async {
    final _preferences = await SharedPreferences.getInstance();
    return _preferences.get(key);
  }

  void set(String key, dynamic value) async {
    final _preferences = await SharedPreferences.getInstance();
    if (value is String) _preferences.setString(key, value);
    if (value is bool) _preferences.setBool(key, value);
    if (value is int) _preferences.setInt(key, value);
    if (value is double) _preferences.setDouble(key, value);
    if (value is List<String>) _preferences.setStringList(key, value);
  }
}