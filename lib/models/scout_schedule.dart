import '../helpers/scouters_schedule_helper.dart';
import 'scout_shift.dart';

class ScoutersSchedule {
  int version;
  List<ScoutShift> shifts;

  List<ScoutShift> filterShiftsWithScouter(String scouterName) {
    if (scouterName.isEmpty) {
      return shifts;
    }

    final shiftsWithScouter = ScoutersScheduleHelper
        .shared.matchSchedule.value.shifts
        .where((element) => element.scouters.contains(scouterName))
        .toList();

    return shiftsWithScouter;
  }

  ScoutersSchedule(this.version, this.shifts);

  factory ScoutersSchedule.fromJson(Map<String, dynamic> json) {
    return ScoutersSchedule(
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
    return shifts.firstWhere(
        (element) => element.matchShiftDuration.range.contains(matchNumber));
  }

  int indexOfScouter({required int matchNumber, required String scouter}) =>
      getShiftFor(matchNumber: matchNumber).scouters.indexOf(scouter);
}
