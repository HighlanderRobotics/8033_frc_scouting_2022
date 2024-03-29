import 'package:shared_preferences/shared_preferences.dart';

enum SharedPreferenceKeys {
  scouters,
  scoutersSchedule,
  matchSchedule,
  tournaments,
  selectedTournamentKey,
  scouterName,
  serverAuthority,
  rotation
}

extension SharedPreferencesKeysExtension on SharedPreferenceKeys {
  String toShortString() => toString().split('.').last;
}

class SharedPreferencesHelper {
  static SharedPreferencesHelper shared = SharedPreferencesHelper();

  final sharedPreferences = SharedPreferences.getInstance();

  Future<String?> getString(String key) async {
    final prefs = await sharedPreferences;
    return prefs.getString(key);
  }

  Future<bool?> setString(String key, String value) async {
    final prefs = await sharedPreferences;
    return prefs.setString(key, value);
  }
}
