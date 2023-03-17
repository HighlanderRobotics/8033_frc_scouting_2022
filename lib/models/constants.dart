import 'package:frc_scouting/models/tournament.dart';
import 'package:flutter/foundation.dart';

class Constants {
  static Constants shared = Constants();

  final tournamentKeys = [
    Tournament("Monterey", "2023camb"),
    Tournament("Fresno", "2023cafr"),
    Tournament("2023 Week 0", "2023week0"),
    if (kDebugMode) Tournament("Chezy 2022 (debug)", "2022cc"),
  ];
}
