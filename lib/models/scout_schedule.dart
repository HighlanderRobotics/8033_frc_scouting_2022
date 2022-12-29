import 'scout_shift.dart';

class ScoutSchedule {
  int version;
  List<ScoutShift> shifts;

  ScoutSchedule(this.version, this.shifts);

  factory ScoutSchedule.fromJson(Map<String, dynamic> json) {
    return ScoutSchedule(
      json["version"],
      json["shifts"]
          .map<ScoutShift>((match) => ScoutShift.fromJson(match))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "version": version,
      "shifts": shifts.map((match) => match.toJson()).toList(),
    };
  }

  bool containsScouter(String scouter) {
    return shifts.any((match) => match.scouters.contains(scouter));
  }

  ScoutShift getShiftFor({required int matchNumber}) {
    return shifts
        .firstWhere((element) => element.matchRange.contains(matchNumber));
  }

  int indexOfScouter({required int matchNumber, required String scouter}) =>
      getShiftFor(matchNumber: matchNumber).scouters.indexOf(scouter);
}
