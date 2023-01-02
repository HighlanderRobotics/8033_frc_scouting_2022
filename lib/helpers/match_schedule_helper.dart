import 'dart:convert';

import 'package:frc_scouting/models/scout_shift.dart';
import 'package:frc_scouting/networking/scouting_server_api.dart';
import 'package:get/get.dart';

import '../models/match_event.dart';
import '../models/service.dart';
import 'shared_preferences_helper.dart';

class MatchScheduleHelper extends ServiceClass {
  static MatchScheduleHelper shared = MatchScheduleHelper();
  late RxList<MatchEvent> matchSchedule;

  @override
  void refresh({bool networkRefresh = false}) {
    try {
      getMatchSchedule(tournamentKey: "2022cc", networkRefresh: networkRefresh);
    } catch (_) {}
  }

  MatchScheduleHelper() {
    matchSchedule = RxList.empty();
    service = Service(name: "Match Schedule").obs;
  }

  List<MatchEvent> getMatchesFromShifts(
      {required List<ScoutShift> shifts, required String scouterName}) {
    var matches = <MatchEvent>[];

    for (var match in matchSchedule) {
      for (var shift in shifts) {
        if (match.key.contains("_${shift.scouterPlacement(scouterName)}") &&
            shift.matchShiftDuration.range.contains(match.matchNumber)) {
          matches.add(match);
          break;
        }
      }
    }

    matches.sort((a, b) => a.matchNumber.compareTo(b.matchNumber));

    return matches;
  }

  Future getMatchSchedule(
      {bool networkRefresh = false, required String tournamentKey}) async {
    service.value
        .updateStatus(ServiceStatus.inProgress, "Fetching from localStorage");
    final localStorageSchedule = await _getParsedLocalStorageSchedule();

    if (localStorageSchedule.isEmpty || networkRefresh) {
      try {
        matchSchedule.value =
            await ScoutingServerAPI.getMatches(tournamentKey: tournamentKey);
        matchSchedule.sort((a, b) => a.key.compareTo(b.key));
        _saveParsedLocalStorageSchedule(matchSchedule.toList());
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
