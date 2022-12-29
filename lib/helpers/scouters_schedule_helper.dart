import 'dart:convert';
import 'package:get/get.dart';

import '../models/scout_schedule.dart';
import '../networking/scouting_server_api.dart';
import 'shared_preferences_helper.dart';

class ScoutersScheduleHelper {
  static ScoutersScheduleHelper shared = ScoutersScheduleHelper();

  late Rx<ScoutSchedule> matchSchedule;

  ScoutersScheduleHelper() {
    matchSchedule = ScoutSchedule(0, RxList.empty()).obs;
  }

  Future getScoutersSchedule({bool forceFetch = false}) async {
    final localStorageSchedule = await _getParsedLocalStorageSchedule();

    if (localStorageSchedule == null || forceFetch) {
      try {
        matchSchedule.value = await ScoutingServerAPI.getScoutersSchedule();
        _saveParsedLocalStorageSchedule(matchSchedule.value);
      } catch (e) {
        rethrow;
      }
    } else {
      matchSchedule.value = localStorageSchedule;
    }
  }

  static Future<ScoutSchedule?> _getParsedLocalStorageSchedule() async {
    final scheduleJson = await SharedPreferencesHelper.shared.getString(
        SharedPreferenceKeys.scoutersSchedule.toShortString());

    if (scheduleJson.isNotEmpty) {
      try {
        return ScoutSchedule.fromJson(jsonDecode(scheduleJson));
      } catch (e) {
        print("Failed to parse localStorage schedule: $e");
        return null;
      }
    } else {
      return null;
    }
  }

  static Future _saveParsedLocalStorageSchedule(ScoutSchedule schedule) async {
    final prefs = await SharedPreferencesHelper.shared.sharedPreferences;
    final scheduleJson = jsonEncode(schedule);
    prefs.setString('scoutersSchedule', scheduleJson);
  }
}
