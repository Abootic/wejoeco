import 'package:shared_preferences/shared_preferences.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SharedRepository {
  Future<void> setData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
    print("Saved $key: $value"); // Debug log
  }

  Future<String?> getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(key);
    print("Retrieved $key: $value"); // Debug log
    return value;
  }

  Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print("Cleared all data"); // Debug log
  }
}