import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHelper {
  Future<String?> getString(String key) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(key);
  }

  Future<bool?> clearAll() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    return null;
  }

  Future<int?> getInt(String key) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt(key);
  }

  Future<bool> getBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? value = prefs.getBool(key);
    return value ?? false;
  }

  Future<double?> getDouble(String key) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getDouble(key)!;
  }

  Future<List<String>?> getStringList(String key) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getStringList(key);
  }

  // Future<Map<String, dynamic>> getObject(String key) async {
  //   final SharedPreferences preferences = await SharedPreferences.getInstance();
  //   return preferences.getString(key)! as Map<String, dynamic>;
  // }

  Future<bool> saveString(String key, String value) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(key, value);
  }

  Future<bool> saveInt(String key, int value) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setInt(key, value);
  }

  Future<bool> saveBool(String key, bool value) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setBool(key, value);
  }

  Future<bool> saveDouble(String key, double value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setDouble(key, value);
  }

  Future<bool> saveStringList(String key, List<String> value) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setStringList(key, value);
  }

  Future<bool> saveObject(String key, value) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(key, jsonEncode(value));
  }
}
