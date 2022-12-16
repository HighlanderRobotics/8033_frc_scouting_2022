import 'dart:convert';

import '../models/match_data/match_data.dart';
import 'package:http/http.dart' as http;

import '../models/scouter.dart';

class ScoutingServerAPI {
  // An Internal function to make a network request and decode the json
  // into a List of Scouter objects
  static Future<List<Scouter>> fetchScouters() async {
    try {
      var response =
          await http.get(Uri.parse('https://v0v0q.mocklab.io/allscouters'));

      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List<dynamic>)
            .map((e) => Scouter.fromJson(e))
            .toList();
      } else {
        print("Non-200 response");
        throw Exception("Non-200 response");
      }
    } catch (e) {
      print("Failed decoding scouters - network response error $e");
      throw Exception(e);
    }
  }

  static Future addScoutReport(MatchData matchData) async {
    try {
      final response = await http.post(
        Uri.parse('https://v0v0q.mocklab.io/addscoutreport'),
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
