import 'package:frc_scouting/models/tournament.dart';
import 'package:flutter/foundation.dart';

class Constants {
  static Constants shared = Constants();

  final tournamentKeys = [
    Tournament(name: "Monterey", key: "2023camb"),
    Tournament(name: "Fresno", key: "2023cafr"),
    Tournament(name: "2023 Week 0", key: "2023week0"),
    Tournament(name: "2023 PNW District SunDome", key: "2023wayak"),
    Tournament(name: "2023 PNW District Glacier Peak", key: "2023wasno"),
    Tournament(name: "Finger Lakes Regional 2023", key: "2023nyro"),
    Tournament(name: "New York Tech Valley Regional 2023", key: "2023nytr"),
    if (kDebugMode) Tournament(name: "Chezy 2022 (debug)", key: "2022cc"),
  ];
}
