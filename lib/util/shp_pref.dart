import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static Future<bool> saveData({String? key, required String value}) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(key!, value);
    return true;
  }

  static Future<String?> getData({String? key}) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString(key!);
  }
}
