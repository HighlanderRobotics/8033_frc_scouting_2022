import 'package:frc_scouting/models/tournament.dart';
import 'package:flutter/foundation.dart';

class Constants {
  static Constants shared = Constants();

  final tournamentKeys = [
    Tournament("2023 Week 0", "2023week0"),
    Tournament("Fresno", "2023cafr"),
    Tournament("Monterey", "2023camb"),
    if (kDebugMode) Tournament("Chezy 2022 (debug)", "2022cc"),
    Tournament("2023 PNW District Auburn", "2023waahs"),
    Tournament("2023 PNW District SunDome", "2023wayak"),
    Tournament("2023 PNW District Glacier Peak", "2023wasno"),
  ];
}
