import 'package:frc_scouting/helpers/match_schedule_helper.dart';

import 'match_key.dart';

class MatchScoutShiftDuration {
  final int startOrdinalNumber;
  final int endOrdinalNumber;

  MatchScoutShiftDuration(this.startOrdinalNumber, this.endOrdinalNumber);

  Set<int> get range {
    final Set<int> range = {};

    for (int i = startOrdinalNumber; i <= endOrdinalNumber; i++) {
      range.add(i);
    }

    return range;
  }

  MatchKey? get startMatchKey {
    return MatchScheduleHelper.shared.matchSchedule
        .firstWhere(
            (match) => match.key.contains(startOrdinalNumber.toString()))
        .matchKey;
  }

  MatchKey? get endMatchKey {
    return MatchScheduleHelper.shared.matchSchedule
        .firstWhere((match) => match.key.contains(endOrdinalNumber.toString()))
        .matchKey;
  }
}
