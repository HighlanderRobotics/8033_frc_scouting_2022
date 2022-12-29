import 'dart:convert';

import 'package:frc_scouting/networking/scouting_server_api.dart';
import 'package:get/get.dart';

import 'shared_preferences_helper.dart';

class MatchScheduleHelper {
  late RxList<MatchEvent> matchSchedule;

  MatchScheduleHelper() {
    matchSchedule = RxList.empty();
  }

  Future getMatchSchedule(
      {bool forceFetch = false, required String tournamentKey}) async {
    final localStorageSchedule = await _getParsedLocalStorageSchedule();

    if (localStorageSchedule.isNotEmpty || forceFetch) {
      try {
        matchSchedule.value =
            await ScoutingServerAPI.getMatches(tournamentKey: tournamentKey);
        matchSchedule.value.sort((a, b) => a.key.compareTo(b.key));
        _saveParsedLocalStorageSchedule(matchSchedule.toList());
      } catch (e) {
        rethrow;
      }
    } else {
      matchSchedule.value = localStorageSchedule;
    }
  }

  static Future<List<MatchEvent>> _getParsedLocalStorageSchedule() async {
    final scheduleJson = await SharedPreferencesHelper.getString(
        SharedPreferenceKeys.matchSchedule.toShortString());

    if (scheduleJson.isNotEmpty) {
      try {
        return (jsonDecode(scheduleJson) as List)
            .map((e) => MatchEvent.fromJson(e))
            .toList();
      } catch (e) {
        print("Failed to parse localStorage schedule: $e");
        return [];
      }
    } else {
      return [];
    }
  }

  static Future _saveParsedLocalStorageSchedule(
      List<MatchEvent> schedule) async {
    final scheduleJson = jsonEncode(schedule);
    await SharedPreferencesHelper.setString(
        SharedPreferenceKeys.matchSchedule.toShortString(), scheduleJson);
  }

  MatchEvent getMatchEventFrom(
          {required int matchNumber, required int scouterId}) =>
      matchSchedule[matchSchedule
              .indexWhere((element) => element.matchNumber == matchNumber) +
          scouterId];
}
