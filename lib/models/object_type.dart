import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ObjectType { cube, cone }

extension ObjectTypeExtension on ObjectType {
  String get displayTitle {
    switch (this) {
      case ObjectType.cube:
        return "Cube";
      case ObjectType.cone:
        return "Cone";
    }
  }

  Color get displayBackgroundColor {
    switch (this) {
      case ObjectType.cube:
        return const Color.fromRGBO(152, 55, 195, 1);
      case ObjectType.cone:
        return const Color.fromRGBO(222, 200, 123, 1);
    }
  }

  String get displayImagePath {
    switch (this) {
      case ObjectType.cube:
        return "assets/cube.png";
      case ObjectType.cone:
        return "assets/cone.png";
    }
  }

  // get haptic feedback for objectType
  void playHapticFeedback() {
    switch (this) {
      case ObjectType.cube:
        HapticFeedback.lightImpact();
        break;
      case ObjectType.cone:
        HapticFeedback.heavyImpact();
        break;
    }
  }
}
