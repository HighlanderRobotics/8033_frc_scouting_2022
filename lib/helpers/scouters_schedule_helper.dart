import 'dart:convert';
import 'package:get/get.dart';

import '../networking/scouting_server_api.dart';
import 'shared_preferences_helper.dart';

class ScoutersScheduleHelper {
  late Rx<ScoutSchedule> matchSchedule;

  ScoutersScheduleHelper() {
    matchSchedule = ScoutSchedule(0, RxList.empty()).obs;
  }

  Future getScoutersSchedule({bool forceFetch = false}) async {
    try {
      final localStorageSchedule = await _getParsedLocalStorageSchedule();

      if (localStorageSchedule == null || forceFetch) {
        matchSchedule.value = await ScoutingServerAPI.fetchScoutersSchedule();
        _saveParsedLocalStorageSchedule(matchSchedule.value);
      } else {
        matchSchedule.value = localStorageSchedule;
      }
    } catch (e) {
      throw "Error getting scouters schedule: $e";
    }
  }

  static Future<ScoutSchedule?> _getParsedLocalStorageSchedule() async {
    final scheduleJson = await SharedPreferencesHelper.getString(
        SharedPreferenceKeys.scoutersSchedule.toShortString());

    if (scheduleJson.isNotEmpty) {
      try {
        return ScoutSchedule.fromJson(jsonDecode(scheduleJson));
      } catch (e) {
        print("Failed to parse localStorage schedule: $e");
        rethrow;
      }
    } else {
      return null;
    }
  }

  Future _saveParsedLocalStorageSchedule(ScoutSchedule schedule) async {
    final prefs = await SharedPreferencesHelper.sharedPreferences;
    final scheduleJson = jsonEncode(schedule);
    prefs.setString('scoutersSchedule', scheduleJson);
  }
}

class ScoutSchedule {
  int version;
  List<ScoutShift> shifts;

  ScoutSchedule(this.version, this.shifts);

  factory ScoutSchedule.fromJson(Map<String, dynamic> json) {
    return ScoutSchedule(
      json["version"],
      json["shifts"]
          .map<ScoutShift>((match) => ScoutShift.fromJson(match))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "version": version,
      "shifts": shifts.map((match) => match.toJson()).toList(),
    };
  }

  bool containsScouter(String scouter) {
    return shifts.any((match) => match.scouters.contains(scouter));
  }
}

class ScoutShift {
  int start;
  int end;
  List<String> scouters;

  ScoutShift(this.start, this.end, this.scouters);

  factory ScoutShift.fromJson(Map<String, dynamic> json) {
    return ScoutShift(
      json["start"],
      json["end"],
      json["scouts"].map<String>((scouter) => scouter.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "start": start,
      "end": end,
      "scouts": scouters.map((scouter) => scouter.toString()).toList(),
    };
  }
}
