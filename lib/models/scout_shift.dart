import 'package:frc_scouting/models/match_scout_shift_duration.dart';

class ScoutShift {
  MatchScoutShiftDuration matchShiftDuration;
  List<String> scouters;

  ScoutShift(this.matchShiftDuration, this.scouters);

  factory ScoutShift.fromJson(Map<String, dynamic> json) {
    return ScoutShift(
      MatchScoutShiftDuration(
          json["start"], json["end"], json["startKey"], json["endKey"]),
      json["scouts"].map<String>((scouter) => scouter.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        "start": matchShiftDuration.startTime.rawMatchNumber,
        "end": matchShiftDuration.endTime.rawMatchNumber,
        "startKey": matchShiftDuration.startTime.matchKey.longMatchKey,
        "endKey": matchShiftDuration.endTime.matchKey.longMatchKey,
        "scouts": scouters.map((scouter) => scouter.toString()).toList(),
      };

  String get localizedDescription =>
      matchShiftDuration.startTime.matchKey.localizedDescription;

  int scouterPlacement(String scouterName) => scouters.indexOf(scouterName);
}
