import 'dart:ui';

import 'package:flutter/services.dart';

enum Level {
  bottomRow,
  middleRow,
  topRow,
}

extension LevelExtension on Level {
  String get localizedDescription {
    switch (this) {
      case Level.bottomRow:
        return "Bottom Row";
      case Level.middleRow:
        return "Middle Row";
      case Level.topRow:
        return "Top Row";
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

  void playHapticFeedback() {
    switch (this) {
      case Level.bottomRow:
        HapticFeedback.lightImpact();
        break;
      case Level.middleRow:
        HapticFeedback.mediumImpact();
        break;
      case Level.topRow:
        HapticFeedback.heavyImpact();
        break;
    }
  }
}
