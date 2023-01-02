import 'dart:convert';
import 'package:frc_scouting/models/service.dart';
import 'package:get/get.dart';

import '../models/scout_schedule.dart';
import '../networking/scouting_server_api.dart';
import 'shared_preferences_helper.dart';

class ScoutersScheduleHelper extends ServiceClass {
  static ScoutersScheduleHelper shared = ScoutersScheduleHelper();

  late Rx<ScoutersSchedule> matchSchedule;

  ScoutersScheduleHelper() {
    matchSchedule = ScoutersSchedule(0, RxList.empty()).obs;
    service = Service(name: "Scouters Schedule").obs;
  }

  @override
  void refresh({bool networkRefresh = false}) {
    try {
      getScoutersSchedule(networkRefresh: networkRefresh);
    } catch (e) {}
  }

  Future getScoutersSchedule({bool networkRefresh = false}) async {
    service.value
        .updateStatus(ServiceStatus.inProgress, "Fetching from localStorage");
    final localStorageSchedule = await _getParsedLocalStorageSchedule();

    if (localStorageSchedule == null || networkRefresh) {
      try {
        matchSchedule.value = await ScoutingServerAPI.getScoutersSchedule();
        _saveParsedLocalStorageSchedule(matchSchedule.value);
        service.value.updateStatus(ServiceStatus.up, "Retrieved from network");
      } catch (e) {
        service.value.updateStatus(
            ServiceStatus.error, "Network or parsing error: ${e.toString()}");
      }
    } else {
      matchSchedule.value = localStorageSchedule;
      service.value
          .updateStatus(ServiceStatus.up, "Retrieved from localStorage");
    }
  }

  static Future<ScoutersSchedule?> _getParsedLocalStorageSchedule() async {
    final scheduleJson = await SharedPreferencesHelper.shared
        .getString(SharedPreferenceKeys.scoutersSchedule.toShortString());

    if (scheduleJson.isNotEmpty) {
      try {
        return ScoutersSchedule.fromJson(jsonDecode(scheduleJson));
      } catch (e) {
        print("Failed to parse localStorage schedule: $e");
        return null;
      }
    } else {
      return null;
    }
  }

  static Future _saveParsedLocalStorageSchedule(
      ScoutersSchedule schedule) async {
    final prefs = await SharedPreferencesHelper.shared.sharedPreferences;
    final scheduleJson = jsonEncode(schedule);
    prefs.setString('scoutersSchedule', scheduleJson);
  }
}
