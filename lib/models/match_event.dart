import 'match_type.dart';

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

  String get localizedDescription =>
      "${matchType.localizedDescription} $matchNumber";

  static String formatMatchKey(String matchKey) =>
      "${MatchTypeExtension.fromShortName(matchKey.substring(0, 2)).localizedDescription} ${matchKey.substring(2)}";
}
