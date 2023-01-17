import 'dart:core';

import 'match_type.dart';

class MatchKey {
  late MatchType matchType;
  late int matchNumber;

  MatchKey({
    required this.matchType,
    required this.matchNumber,
  });

  // like 'qf1'
  MatchKey.fromJsonUsingShortKeyForm(String jsonString) {
    try {
      matchType = MatchTypeExtension.fromShortName(jsonString.substring(0, 2));
      matchNumber = int.parse(jsonString.substring(2));
    } catch (e) {
      throw Exception("Failed to parse short form match key.");
    }
  }

  MatchKey.fromJsonUsingLongKeyForm(String jsonString) {
    try {
      final matchKey =
          MatchKey.fromJsonUsingShortKeyForm(jsonString.substring(7));
      matchType = matchKey.matchType;
      matchNumber = matchKey.matchNumber;
    } catch (e) {
      throw Exception("Failed to parse long form match key.");
    }
  }

  String get localizedDescription =>
      "${matchType.localizedDescription} $matchNumber";

  String get shortMatchKey => "${matchType.shortName}$matchNumber";
}
