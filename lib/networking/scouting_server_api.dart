import 'dart:convert';

import 'package:frc_scouting/helpers/scouters_schedule_helper.dart';

import '../models/match_data/match_data.dart';
import 'package:http/http.dart' as http;

class ScoutingServerAPI {
  // An Internal function to make a network request and decode the json
  // into a List of Scouter objects

  static final String _host = "https://c2d8-192-184-160-226.ngrok.io";

  static Future<List<String>> fetchScouters() async {
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

  static Future<ScoutSchedule> fetchScoutersSchedule() async {
    try {
      var response = await http.get(Uri.parse('$_host/scoutersschedule'));

      if (response.statusCode == 200) {
        return ScoutSchedule.fromJson(jsonDecode(response.body));
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
        Uri.parse('$_host/addscoutreport'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
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
}
