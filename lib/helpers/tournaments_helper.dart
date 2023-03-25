import 'dart:convert';

import 'package:frc_scouting/helpers/shared_preferences_helper.dart';
import 'package:frc_scouting/models/tournament.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/match_event.dart';
import '../models/service.dart';
import '../networking/scouting_server_api.dart';

class TournamentsHelper extends ServiceClass {
  static TournamentsHelper shared = TournamentsHelper();
  late RxList<Tournament> tournaments;

  @override
  void refresh({bool networkRefresh = false}) {
    try {
      getTournaments(networkRefresh: networkRefresh);
    } catch (_) {}
  }

  TournamentsHelper() {
    tournaments = RxList.empty();
    service = Service(name: "Tournaments").obs;
  }

  Future getTournaments({
    bool networkRefresh = false,
  }) async {
    service.value
        .updateStatus(ServiceStatus.inProgress, "Fetching from localStorage");
    final localTournaments = await _getParsedLocalStorageTournaments();

    if (localTournaments.isEmpty || networkRefresh) {
      try {
        tournaments.value = await ScoutingServerAPI.shared.getTournaments();
        _saveParsedLocalStorageTournaments(tournaments);
        service.value.updateStatus(ServiceStatus.up, "Retrieved from network");
      } catch (e) {
        service.value.updateStatus(
            ServiceStatus.error, "Network or parsing error: ${e.toString()}");
      }
    } else {
      tournaments.value = localTournaments;
      service.value
          .updateStatus(ServiceStatus.up, "Retrieved from localStorage");
    }
  }

  Future<List<Tournament>> _getParsedLocalStorageTournaments() async {
    final tournaments = await SharedPreferencesHelper.shared
            .getString(SharedPreferenceKeys.tournaments.toShortString()) ??
        "";

    if (tournaments.isNotEmpty) {
      try {
        return (jsonDecode(tournaments) as List)
            .map((e) => Tournament.fromJson(e))
            .toList();
      } catch (e) {
        print("Failed to parse tournaments from localStorage: $e");
        return [];
      }
    } else {
      return [];
    }
  }

  Future _saveParsedLocalStorageTournaments(
      List<Tournament> tournaments) async {
    var tournamentsJson = jsonEncode(tournaments);
    await SharedPreferencesHelper.shared.setString(
        SharedPreferenceKeys.tournaments.toShortString(), tournamentsJson);
  }
}
