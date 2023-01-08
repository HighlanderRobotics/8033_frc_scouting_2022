enum MatchType {
  qualifierMatch,
  quarterFinals,
  eliminationFinals,
  semiFinals,
  finals,
  grandFinals
}

extension MatchTypeExtension on MatchType {
  String get localizedDescription {
    switch (this) {
      case MatchType.qualifierMatch:
        return "Qualification";
      case MatchType.quarterFinals:
        return "Quarter Finals";
      case MatchType.eliminationFinals:
        return "Elimination Finals";
      case MatchType.semiFinals:
        return "Semi Finals";
      case MatchType.finals:
        return "Finals";
      case MatchType.grandFinals:
        return "Grand Finals";
    }
  }

  String get shortName {
    switch (this) {
      case MatchType.qualifierMatch:
        return "qm";
      case MatchType.quarterFinals:
        return "qf";
      case MatchType.eliminationFinals:
        return "ef";
      case MatchType.semiFinals:
        return "sf";
      case MatchType.finals:
        return "f";
      case MatchType.grandFinals:
        return "gf";
    }
  }

  static MatchType fromShortName(String shortName) {
    try {
      return MatchType.values
          .firstWhere((element) => element.shortName == shortName);
    } catch (e) {
      throw Exception("Invalid match type");
    }
  }

  static MatchType fromLocalizedDescription(String matchType) {
    try {
      return MatchType.values
          .firstWhere((element) => element.localizedDescription == matchType);
    } catch (e) {
      throw Exception("Invalid match type");
    }
  }
}
