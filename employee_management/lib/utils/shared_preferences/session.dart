import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  Future<String?> getString({required String localStorageKey}) async {
    final prefs = await SharedPreferences.getInstance();
    final result = prefs.getString(localStorageKey);
    return result;
  }

  Future<bool> setString({required String localStorageKey, required String value}) async {
    final prefs = await SharedPreferences.getInstance();
    final result = await prefs.setString(localStorageKey, value);
    return result;
  }

  Future<bool?> getBool({required String localStorageKey}) async {
    final prefs = await SharedPreferences.getInstance();
    final result = prefs.getBool(localStorageKey);
    return result;
  }

  Future<bool> setBool({required String localStorageKey, required bool value}) async {
    final prefs = await SharedPreferences.getInstance();
    final result = await prefs.setBool(localStorageKey, value);
    return result;
  }

  Future<bool> remove({required String localStorageKey}) async {
    final prefs = await SharedPreferences.getInstance();
    final result = await prefs.remove(localStorageKey);
    return result;
  }
}
