import 'int_closed_range.dart';

class ScoutShift {
  IntClosedRange matchRange;
  List<String> scouters;

  ScoutShift(this.matchRange, this.scouters);

  factory ScoutShift.fromJson(Map<String, dynamic> json) {
    return ScoutShift(
      IntClosedRange(json["start"], json["end"]),
      json["scouts"].map<String>((scouter) => scouter.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        "start": matchRange.start,
        "end": matchRange.end,
        "scouts": scouters.map((scouter) => scouter.toString()).toList(),
      };
}
