import 'match_type.dart';

class MatchScoutShiftDuration {
  final MatchScoutShiftTime start;
  final MatchScoutShiftTime end;

  MatchScoutShiftDuration(int start, int end)
      : start = MatchScoutShiftTime(
            start, MatchTypeExtension.fromRawMatchNumber(start)),
        end = MatchScoutShiftTime(
            end, MatchTypeExtension.fromRawMatchNumber(end));

  Set<int> get range {
    final Set<int> range = {};

    for (int i = start.rawMatchNumber; i <= end.rawMatchNumber; i++) {
      range.add(i);
    }

    return range;
  }
}

class MatchScoutShiftTime {
  final int rawMatchNumber;
  final MatchType eventType;

  MatchScoutShiftTime(this.rawMatchNumber, this.eventType);

  int get eventTypeMatchNumber {
    // switch (eventType) {
    //   case MatchType.elimination:
    //     return rawMatchNumber;
    //   case MatchType.qualification:
    //     return (rawMatchNumber > 65 ? rawMatchNumber - 65 : rawMatchNumber);
    // }
    return rawMatchNumber;
  }
}
