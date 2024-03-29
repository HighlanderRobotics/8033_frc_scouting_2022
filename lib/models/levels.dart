import 'dart:ui';

import 'package:flutter/services.dart';

enum Level { bottomRow, middleRow, topRow }

extension LevelExtension on Level {
  String get localizedDescription {
    switch (this) {
      case Level.bottomRow:
        return "Hybrid";
      case Level.middleRow:
        return "Middle";
      case Level.topRow:
        return "Top";
    }
  }

  Color get displayColor {
    switch (this) {
      case Level.bottomRow:
        return const Color.fromRGBO(222, 200, 123, 1);
      case Level.middleRow:
        return const Color.fromRGBO(180, 142, 10, 1);
      case Level.topRow:
        return const Color.fromRGBO(255, 199, 0, 1);
    }
  }
}
