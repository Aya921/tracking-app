import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferHelper {
  // ✅ Save data
  static Future<void> setData(String key, dynamic value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else {
      throw Exception('Unsupported type');
    }
  }

  static Future<String?> getString(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
  static Future<bool?> getBool(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }
  ///  Check if token exists
  static Future<bool> isLogin(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(key);
    return value != null && value.isNotEmpty;
  }

  ///  Remove specific data
  static Future<void> removeData(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  /// Clear all
  static Future<void> clearAllData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
  ///SET Secure String
static setSecureString(String key,String value)async{
 const storage = FlutterSecureStorage();
 await storage.write(key: key, value: value);
}
  ///SET Secure String
  static getSecureString(String key)async{
    const storage = FlutterSecureStorage();
    await storage.read(key: key);
  }
}
