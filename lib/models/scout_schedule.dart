import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lzstring/lzstring.dart';

import '../helpers/scouters_schedule_helper.dart';
import 'scout_shift.dart';

class ScoutersSchedule {
  RxInt version;
  RxList<ScoutShift> shifts;

  List<ScoutShift> filterShiftsWithScouter(String scouterName) {
    if (scouterName.isEmpty) {
      return this.shifts;
    }

    var shifts = ScoutersScheduleHelper.shared.matchSchedule.value.shifts
        .where((element) => element.scouters.contains(scouterName))
        .toList();

    return shifts;
  }

  ScoutersSchedule(this.version, this.shifts);

  factory ScoutersSchedule.fromJson(Map<String, dynamic> json) {
    return ScoutersSchedule(
      RxInt(json["version"]),
      RxList(json["shifts"]
          .map<ScoutShift>((match) => ScoutShift.fromJson(match))
          .toList()),
    );
  }

  factory ScoutersSchedule.fromCompressedJSON(String compressed) =>
      ScoutersSchedule.fromJson(
          jsonDecode(LZString.decompressFromUTF16Sync(compressed) ?? ""));

  Map<String, dynamic> toJson() {
    return {
      "version": version.value,
      "shifts": shifts.toList().map((match) => match.toJson()).toList(),
    };
  }

  bool containsScouter(String scouter) {
    return shifts.any((match) => match.scouters.contains(scouter));
  }

  ScoutShift getShiftFor({
    required int matchNumber,
  }) {
    return shifts.firstWhere(
        (element) => element.matchShiftDuration.range.contains(matchNumber));
  }

  int indexOfScouter({
    required int matchNumber,
    required String scouter,
  }) =>
      getShiftFor(matchNumber: matchNumber).scouters.indexOf(scouter);

  Color get getVersionColor =>
      HSLColor.fromAHSL(1, (version.toDouble() * 82) % 360, 0.5, 0.5).toColor();
}
