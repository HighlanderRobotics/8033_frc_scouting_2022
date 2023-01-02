import 'package:frc_scouting/models/int_closed_range.dart';

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
        "start": matchShiftDuration.start.rawMatchNumber,
        "end": matchShiftDuration.end.rawMatchNumber,
        "scouts": scouters.map((scouter) => scouter.toString()).toList(),
      };

  String get localizedDescription =>
      "${matchShiftDuration.start.eventType.name} ${matchShiftDuration.start.eventTypeMatchNumber}";

  int scouterPlacement(String scouterName) => scouters.indexOf(scouterName);
}
