import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class TheBlueAllianceAPI {
  Future<List<List<int>>> getMatchSchedule(String event) async {
    List<List<int>> teams = [];

    try {
      var response = await http.get(
          Uri.parse(
              'https://www.thebluealliance.com/api/v3/event/$event/matches/simple'),
          headers: {"X-TBA-Auth-Key": dotenv.env['X-TBA-Auth-Key'] ?? "OH NO"});
      if (response.statusCode == 200) {
        jsonDecode(response.body).forEach((match) {
          teams.add([
            int.parse((match['alliances']['blue']['team_keys'][0] as String)
                .substring(3)),
            int.parse((match['alliances']['blue']['team_keys'][1] as String)
                .substring(3)),
            int.parse((match['alliances']['blue']['team_keys'][2] as String)
                .substring(3)),
            int.parse((match['alliances']['red']['team_keys'][0] as String)
                .substring(3)),
            int.parse((match['alliances']['red']['team_keys'][1] as String)
                .substring(3)),
            int.parse((match['alliances']['red']['team_keys'][2] as String)
                .substring(3)),
          ]);
        });

        return teams;
      } else {
        throw Exception('Failed to load match schedule');
      }
    } catch (e) {
      // print("Failed to load match schedule: $e");
      throw Exception("Failed to load match schedule: $e");
    }
  }
}
