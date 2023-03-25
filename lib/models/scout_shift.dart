import 'package:frc_scouting/models/match_scout_shift_duration.dart';

class ScoutShift {
  MatchScoutShiftDuration matchShiftDuration;
  List<String> scouters;

  ScoutShift(this.matchShiftDuration, this.scouters);

  factory ScoutShift.fromJson(Map<String, dynamic> json) {
    return ScoutShift(
      MatchScoutShiftDuration(json["start"], json["end"]),
      json["scouts"].map<String>((scouter) => scouter.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        "start": matchShiftDuration.startOrdinalNumber,
        "end": matchShiftDuration.endOrdinalNumber,
        "scouts": scouters.map((scouter) => scouter.toString()).toList(),
      };

  String get localizedDescription =>
      matchShiftDuration.startMatchKey?.localizedDescription ??
      "Unknown Match Key";

  int scouterPlacement(String scouterName) => scouters.indexOf(scouterName);
}
