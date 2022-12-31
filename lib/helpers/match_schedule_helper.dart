import 'dart:convert';

import 'package:frc_scouting/networking/scouting_server_api.dart';
import 'package:get/get.dart';

import '../models/service.dart';
import 'shared_preferences_helper.dart';

class MatchScheduleHelper extends ServiceClass {
  static MatchScheduleHelper shared = MatchScheduleHelper();
  late RxList<MatchEvent> matchSchedule;

  @override
  void forceRefresh() {
    try {
      getMatchSchedule(tournamentKey: "2022cc", forceFetch: true);
    } catch (_) {}
  }

  MatchScheduleHelper() {
    matchSchedule = RxList.empty();
    service = Service(name: "Match Schedule").obs;
  }

  Future getMatchSchedule(
      {bool forceFetch = false, required String tournamentKey}) async {
    service.value
        .updateStatus(ServiceStatus.inProgress, "Fetching from localStorage");
    final localStorageSchedule = await _getParsedLocalStorageSchedule();

    if (localStorageSchedule.isNotEmpty || forceFetch) {
      try {
        matchSchedule.value =
            await ScoutingServerAPI.getMatches(tournamentKey: tournamentKey);
        matchSchedule.sort((a, b) => a.key.compareTo(b.key));
        _saveParsedLocalStorageSchedule(matchSchedule.toList());
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

  Future<List<MatchEvent>> _getParsedLocalStorageSchedule() async {
    final scheduleJson = await SharedPreferencesHelper.shared
        .getString(SharedPreferenceKeys.matchSchedule.toShortString());

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

  Future _saveParsedLocalStorageSchedule(List<MatchEvent> schedule) async {
    final scheduleJson = jsonEncode(schedule);
    await SharedPreferencesHelper.shared.setString(
        SharedPreferenceKeys.matchSchedule.toShortString(), scheduleJson);
  }

  MatchEvent getMatchEvent(
          {required int matchNumber, required int scouterId}) =>
      matchSchedule[matchSchedule
              .indexWhere((element) => element.matchNumber == matchNumber) +
          scouterId];
}
