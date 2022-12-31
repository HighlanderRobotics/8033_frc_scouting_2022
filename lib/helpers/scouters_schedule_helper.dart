import 'dart:convert';
import 'package:frc_scouting/models/service.dart';
import 'package:get/get.dart';

import '../models/scout_schedule.dart';
import '../networking/scouting_server_api.dart';
import 'shared_preferences_helper.dart';

class ScoutersScheduleHelper extends ServiceClass {
  static ScoutersScheduleHelper shared = ScoutersScheduleHelper();

  late Rx<ScoutSchedule> matchSchedule;

  ScoutersScheduleHelper() {
    matchSchedule = ScoutSchedule(0, RxList.empty()).obs;
    service = Service(name: "Scouters Schedule").obs;
  }

  @override
  void forceRefresh() {
    try {
      getScoutersSchedule(forceFetch: true);
    } catch (e) {}
  }

  Future getScoutersSchedule({bool forceFetch = false}) async {
    service.value
        .updateStatus(ServiceStatus.inProgress, "Fetching from localStorage");
    final localStorageSchedule = await _getParsedLocalStorageSchedule();

    if (localStorageSchedule == null || forceFetch) {
      try {
        matchSchedule.value = await ScoutingServerAPI.getScoutersSchedule();
        _saveParsedLocalStorageSchedule(matchSchedule.value);
        service.value.updateStatus(ServiceStatus.up, "Retrieved from network");
      } catch (e) {
        service.value.updateStatus(
            ServiceStatus.error, "Network error: ${e.toString()}");
      }
    } else {
      matchSchedule.value = localStorageSchedule;
      service.value
          .updateStatus(ServiceStatus.up, "Retrieved from localStorage");
    }
  }

  static Future<ScoutSchedule?> _getParsedLocalStorageSchedule() async {
    final scheduleJson = await SharedPreferencesHelper.shared
        .getString(SharedPreferenceKeys.scoutersSchedule.toShortString());

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
