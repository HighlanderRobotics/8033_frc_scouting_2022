import 'package:shared_preferences/shared_preferences.dart';

enum SharedPreferenceKeys { scouters, scoutersSchedule, matchSchedule }

extension SharedPreferencesKeysExtension on SharedPreferenceKeys {
  String toShortString() => toString().split('.').last;
}

class SharedPreferencesHelper {
  static final sharedPreferences = SharedPreferences.getInstance();

  static Future<String> getString(String key) async {
    final prefs = await sharedPreferences;
    return prefs.getString(key) ?? "";
  }

  static Future<bool> setString(String key, String value) async {
    final prefs = await sharedPreferences;
    return prefs.setString(key, value);
  }
}
