import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/match_data.dart';
import 'package:http/http.dart' as http;

import '../models/match_event.dart';
import '../models/scout_schedule.dart';

class ScoutingServerAPI {
  // An Internal function to make a network request and decode the json
  // into a List of Scouter objects

  static const String _host = "https://4585-75-111-65-32.ngrok.io";

  static Future<List<String>> getScouters() async {
    try {
      var response =
          await http.get(Uri.parse('$_host/API/manager/getScouters'));

      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List<dynamic>)
            .map((e) => e.toString())
            .toList();
      } else {
        print("Non-200 response");
        throw Exception("Non-200 response");
      }
    } catch (e) {
      print("Failed decoding scouters - network response error: $e");
      throw Exception(e);
    }
  }

  static Future<ScoutersSchedule> getScoutersSchedule() async {
    try {
      var response =
          await http.get(Uri.parse('$_host/API/manager/getScoutersSchedule'));

      if (response.statusCode == 200) {
        return ScoutersSchedule.fromJson(jsonDecode(response.body));
      } else {
        print("Non-200 response");
        throw Exception("Non-200 response");
      }
    } catch (e) {
      print("Failed decoding scouters schedule - network response error $e");
      throw Exception(e);
    }
  }

  static Future addScoutReport(MatchData matchData) async {
    try {
      final response = await http.post(
        Uri.parse('$_host/API/manager/addScoutReport'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(matchData.toJson()),
      );

      if (response.statusCode == 200) {
        print("Successfully added scout report");
      } else {
        print("Non-200 response");
        throw Exception("Non-200 response");
      }
    } catch (e) {
      print("Failed adding scout report - network response error $e");
      throw Exception(e);
    }
  }

  static Future<List<MatchEvent>> getMatches(
      {required String tournamentKey}) async {
    final response = await http.get(Uri.parse(
        '$_host/API/manager/getMatches/?tournamentKey=$tournamentKey'));

    if (response.statusCode == 200) {
      try {
        return (jsonDecode(response.body) as List<dynamic>)
            .map((match) => MatchEvent.fromJson(match))
            .toList();
      } catch (e) {
        print("Failed decoding matches - network response error: $e");
        throw Exception(e);
      }
    } else {
      print("Non-200 response");
      throw Exception("Non-200 response");
    }
  }

  static Future<List<bool>> isMatchesScouted(
      {required String tournamentKey,
      required String scouterName,
      required List<String> matchKeys}) async {
    final response = await http.get(Uri.parse(
        "$_host/API/manager/isMatchesScouted?tournamentKey=2022cc&scouterName=Jacob Trentini&matchKeys=['2022cc_qm1', '2022cc_qm2', '2022cc_qm3'"));

    if (response.statusCode == 200) {
      try {
        return (jsonDecode(response.body) as List<dynamic>)
            .map((match) => match["status"] as bool)
            .toList();
      } catch (e) {
        print("Failed decoding isMatchesScouted - network response error: $e");
        throw Exception(e);
      }
    } else {
      print("Non-200 response");
      throw Exception("Non-200 response");
    }
  }
}
