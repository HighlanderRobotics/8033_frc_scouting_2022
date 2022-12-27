import 'dart:convert';
import 'package:get/get.dart';

import '../networking/scouting_server_api.dart';
import 'shared_preferences_helper.dart';

class ScoutersScheduleHelper {
  late Rx<MatchSchedule> matchSchedule;

  ScoutersScheduleHelper() {
    matchSchedule = MatchSchedule(0, RxList.empty()).obs;
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

  static Future<MatchSchedule?> _getParsedLocalStorageSchedule() async {
    final scheduleJson = await SharedPreferencesHelper.getString(
        SharedPreferenceKeys.scoutersSchedule.toShortString());

    if (scheduleJson.isNotEmpty) {
      try {
        return MatchSchedule.fromJson(jsonDecode(scheduleJson));
      } catch (e) {
        print("Failed to parse localStorage schedule: $e");
        rethrow;
      }
    } else {
      return null;
    }
  }

  Future _saveParsedLocalStorageSchedule(MatchSchedule schedule) async {
    final prefs = await SharedPreferencesHelper.sharedPreferences;
    final scheduleJson = jsonEncode(schedule);
    prefs.setString('scoutersSchedule', scheduleJson);
  }
}

class MatchSchedule {
  int version;
  List<Match> matches;

  MatchSchedule(this.version, this.matches);

  factory MatchSchedule.fromJson(Map<String, dynamic> json) {
    return MatchSchedule(
      json["version"],
      json["matches"].map<Match>((match) => Match.fromJson(match)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "version": version,
      "matches": matches.map((match) => match.toJson()).toList(),
    };
  }

  bool containsScouter(String scouter) {
    return matches.any((match) => match.scouters.contains(scouter));
  }
}

class Match {
  int start;
  int end;
  List<String> scouters;

  Match(this.start, this.end, this.scouters);

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
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
