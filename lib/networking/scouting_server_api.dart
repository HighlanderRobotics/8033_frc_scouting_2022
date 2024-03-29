import 'dart:convert';

import 'package:frc_scouting/models/tournament.dart';
import 'package:get/get.dart';

import '../getx_screens/settings_screen.dart';
import '../helpers/shared_preferences_helper.dart';
import '../models/match_data.dart';
import 'package:http/http.dart' as http;

import '../models/match_event.dart';
import '../models/match_scouted.dart';
import '../models/scout_schedule.dart';
import '../models/settings_screen_variables.dart';

class ScoutingServerAPI {
  static final shared = ScoutingServerAPI();
  // An Internal function to make a network request and decode the json
  // into a List of Scouter objects

  // ignore: prefer_final_fields

  Future<List<String>> getScouters() async {
    try {
      var response = await http.get(Uri.parse(
          'http://${await SharedPreferencesHelper.shared.getString(SharedPreferenceKeys.serverAuthority.toShortString())}/API/manager/getScouters'));

      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List<dynamic>)
            .map((jsonString) => jsonString.toString())
            .toList();
      } else {
        print("HTTP ${response.statusCode} response");
        throw Exception("HTTP ${response.statusCode} response");
      }
    } catch (e) {
      print("Failed decoding scouters - network response error: $e");
      throw Exception(e);
    }
  }

  Future<ScoutersSchedule> getScoutersSchedule() async {
    try {
      var response = await http.get(Uri.parse(
          'http://${await SharedPreferencesHelper.shared.getString(SharedPreferenceKeys.serverAuthority.toShortString())}/API/manager/getScoutersSchedule'));

      if (response.statusCode == 200) {
        return ScoutersSchedule.fromJson(jsonDecode(response.body));
      } else {
        print("HTTP ${response.statusCode} response");
        throw Exception("HTTP ${response.statusCode} response");
      }
    } catch (e) {
      print("Failed decoding scouters schedule - network response error: $e");
      throw Exception(e);
    }
  }

  Future addScoutReport(MatchData matchData) async {
    try {
      final response = await http.post(
        Uri.http(
            (await SharedPreferencesHelper.shared.getString(
                SharedPreferenceKeys.serverAuthority.toShortString()))!,
            '/API/manager/addScoutReport'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
            matchData.toJson(includeUploadStatus: false, usesTBAKey: true)),
      );

      if (response.statusCode == 200) {
        print("Successfully added scout report");
      } else {
        print("HTTP ${response.statusCode} response ${response.reasonPhrase}");
        throw Exception(
            "HTTP ${response.statusCode} response ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Failed adding scout report - network response error $e");
      throw Exception(e);
    }
  }

  Future<List<MatchEvent>> getMatches() async {
    final response = await http.get(Uri.parse(
        'http://${await SharedPreferencesHelper.shared.getString(SharedPreferenceKeys.serverAuthority.toShortString())}/API/manager/getMatches/?tournamentKey=${Get.find<SettingsScreenVariables>().selectedTournamentKey.value.key}'));

    if (response.statusCode == 200) {
      try {
        final jsonMap = jsonDecode(response.body) as List<dynamic>;
        var matches = <MatchEvent>[];

        for (final jsonObject in jsonMap) {
          try {
            matches.add(MatchEvent.fromJson(jsonObject));
          } catch (e) {
            print(e.toString());
          }
        }

        return matches;
      } catch (e) {
        print("Failed decoding matches - network response error: $e");
        throw Exception(e);
      }
    } else {
      print("HTTP ${response.statusCode} response");
      throw Exception("HTTP ${response.statusCode} response");
    }
  }

  Future<List<MatchScouted>> isMatchesScouted({
    required String scouterName,
    required List<String> matchKeys,
  }) async {
    http.Response response;

    try {
      response = await http.get(Uri.parse(
          "http://${await SharedPreferencesHelper.shared.getString(SharedPreferenceKeys.serverAuthority.toShortString())}/API/manager/isMatchesScouted?tournamentKey=${Get.find<SettingsScreenVariables>().selectedTournamentKey.value.key}&scouterName=$scouterName&matchKeys=[${matchKeys.map((e) => '"$e"').join(",")}]"));
    } catch (e) {
      print("Failed isMatchesScouted - network response error: $e");
      throw Exception("Failed isMatchesScouted - network response error: $e");
    }

    if (response.statusCode == 200) {
      try {
        return (jsonDecode(response.body) as List<dynamic>)
            .map((jsonObject) => MatchScouted.fromJson(jsonObject))
            .toList();
      } catch (e) {
        print("Failed decoding isMatchesScouted - network response error: $e");
        throw Exception(e);
      }
    } else {
      print("HTTP ${response.statusCode} response");
      throw Exception("HTTP ${response.statusCode} response");
    }
  }

  Future<List<Tournament>> getTournaments() async {
    final response = await http.get(Uri.parse(
        'http://${await SharedPreferencesHelper.shared.getString(SharedPreferenceKeys.serverAuthority.toShortString())}/API/manager/getTournaments'));

    if (response.statusCode == 200) {
      try {
        var tournaments = <Tournament>[];

        for (final jsonObject in (jsonDecode(response.body) as List<dynamic>)) {
          try {
            tournaments.add(Tournament.fromJson(jsonObject));
          } catch (e) {
            print(e.toString());
          }
        }

        return tournaments;
      } catch (e) {
        print("Failed decoding tournaments - network response error: $e");
        throw Exception(e);
      }
    } else {
      print("HTTP ${response.statusCode} response");
      throw Exception("HTTP ${response.statusCode} response");
    }
  }
}
