import 'dart:convert';

import '../models/match_data/match_data.dart';
import 'package:http/http.dart' as http;

import '../models/scout_schedule.dart';

class ScoutingServerAPI {
  // An Internal function to make a network request and decode the json
  // into a List of Scouter objects

  static const String _host = "http://localhost:4000";

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

  static Future<ScoutSchedule> getScoutersSchedule() async {
    try {
      var response =
          await http.get(Uri.parse('$_host/API/manager/getScoutersSchedule'));

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

  static Future<List<MatchEvent>> getMatches({required String tournamentKey}) async {
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
}

class MatchEvent {
  String key;
  String gameKey;
  int matchNumber;
  String teamKey;
  MatchType matchType;

  MatchEvent(
      {required this.key,
      required this.gameKey,
      required this.matchNumber,
      required this.teamKey,
      required this.matchType});

  factory MatchEvent.fromJson(Map<String, dynamic> json) {
    return MatchEvent(
        key: json['key'],
        gameKey: json['gameKey'],
        matchNumber: json['matchNumber'],
        teamKey: json['teamKey'],
        matchType: MatchTypeExtension.fromShortName(json['matchType']));
  }

  Map<String, dynamic> toJson() => {
        'key': key,
        'gameKey': gameKey,
        'matchNumber': matchNumber,
        'teamKey': teamKey,
        'matchType': matchType.shortName,
      };
}

enum MatchType { qualification, elimination }

extension MatchTypeExtension on MatchType {
  String get name {
    switch (this) {
      case MatchType.qualification:
        return "Qualification";
      case MatchType.elimination:
        return "Elimination";
    }
  }

  String get shortName {
    switch (this) {
      case MatchType.qualification:
        return "qm";
      case MatchType.elimination:
        return "ef";
    }
  }

  static MatchType fromShortName(String shortName) =>
      MatchType.values.firstWhere((element) => element.shortName == shortName);
}
