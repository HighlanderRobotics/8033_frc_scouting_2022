enum MatchType { semiFinals, quarterFinals, eliminationFinals, finals }

extension MatchTypeExtension on MatchType {
  String get localizedDescription {
    switch (this) {
      case MatchType.semiFinals:
        return "Semi-Finals";
      case MatchType.quarterFinals:
        return "Quarter-Finals";
      case MatchType.eliminationFinals:
        return "Elimination Finals";
      case MatchType.finals:
        return "Finals";
    }
  }

  String get shortName {
    switch (this) {
      case MatchType.semiFinals:
        return "sf";
      case MatchType.quarterFinals:
        return "qf";
      case MatchType.eliminationFinals:
        return "ef";
      case MatchType.finals:
        return "f";
    }
  }

  static MatchType fromRawMatchNumber(int rawMatchNumber) => rawMatchNumber > 65
      ? MatchType.quarterFinals
      : MatchType.eliminationFinals;

  static MatchType fromShortName(String shortName) =>
      MatchType.values.firstWhere((element) => element.shortName == shortName);

  static MatchType fromLocalizedDescription(String matchType) =>
      MatchType.values
          .firstWhere((element) => element.localizedDescription == matchType);
}
