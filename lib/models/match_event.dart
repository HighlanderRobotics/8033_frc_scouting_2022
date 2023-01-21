import 'package:frc_scouting/models/match_key.dart';

import 'match_type.dart';

class MatchEvent {
  // like 'qm1_4'
  String key;

  // like '2022cc'
  String gameKey;

  // like 1
  int teamNumber;

  // combination of matchType ('qm') and matchNumber (1)
  MatchKey matchKey;

  MatchEvent({
    required this.key,
    required this.gameKey,
    required this.matchKey,
    required this.teamNumber,
  });

  // like '{"key":"2022cc_qm1_4","tournamentKey":"2022cc","matchNumber":1,"teamKey":"frc254","matchType":"qm", "matchKey": "f1_1"}'
  factory MatchEvent.fromJson(Map<String, dynamic> json) {
    try {
      return MatchEvent(
        key: json['key'],
        gameKey: json['tournamentKey'],
        matchKey: MatchKey(
          matchType: MatchTypeExtension.fromShortName(json['matchType']),
          matchNumber: json['matchNumber'],
        ),
        teamNumber: int.parse((json['teamKey'] as String).substring(3)),
      );
    } catch (e) {
      throw Exception("Failed to parse match event.");
    }
  }

  Map<String, dynamic> toJson() => {
        'key': key,
        'tournamentKey': gameKey,
        'matchNumber': matchKey.matchNumber,
        'teamKey': "frc$teamNumber",
        'matchType': matchKey.matchType.shortName,
      };
}
