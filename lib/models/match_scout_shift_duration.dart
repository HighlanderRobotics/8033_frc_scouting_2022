import 'package:frc_scouting/models/match_key.dart';

import 'match_scout_shift_time.dart';

class MatchScoutShiftDuration {
  final MatchScoutShiftTime startTime;
  final MatchScoutShiftTime endTime;

  MatchScoutShiftDuration(
      int startNumber, int endNumber, String startKey, String endKey)
      : startTime = MatchScoutShiftTime(
            matchKey: MatchKey.fromJsonUsingLongKeyForm(startKey),
            rawMatchNumber: startNumber),
        endTime = MatchScoutShiftTime(
            matchKey: MatchKey.fromJsonUsingLongKeyForm(endKey),
            rawMatchNumber: endNumber);

  Set<int> get range {
    final Set<int> range = {};

    for (int i = startTime.rawMatchNumber; i <= endTime.rawMatchNumber; i++) {
      range.add(i);
    }

    return range;
  }
}
