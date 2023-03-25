import 'package:flutter/material.dart';

enum DriverAbility { terrible, poor, average, good, great }

extension DriverAbilityExtension on DriverAbility {
  String get localizedDescription {
    switch (this) {
      case DriverAbility.terrible:
        return "Terrible";
      case DriverAbility.poor:
        return "Poor";
      case DriverAbility.average:
        return "Average";
      case DriverAbility.good:
        return "Good";
      case DriverAbility.great:
        return "Great";
    }
  }

  String get longLocalizedDescription {
    switch (this) {
      case DriverAbility.terrible:
        return "This driver cannot control the robot at all. They are a hindrance to everyone around them and barely move.";
      case DriverAbility.poor:
        return "This driver struggles to keep the robot under control. They make many mistakes and are not very reliable.";
      case DriverAbility.average:
        return "This driver can operate the robot competently. However, they are not particularly skilled or exceptional.";
      case DriverAbility.good:
        return "This driver can operate the robot with skill and precision. They are reliable and make few mistakes.";
      case DriverAbility.great:
        return "This driver can operate the robot with mastery. They are highly skilled, precise, and efficient and they can think ahead.";
    }
  }

  Color get color {
    switch (this) {
      case DriverAbility.terrible:
        return Colors.red;
      case DriverAbility.poor:
        return Colors.orange;
      case DriverAbility.average:
        return Colors.yellow.shade700;
      case DriverAbility.good:
        return Colors.lightGreen;
      case DriverAbility.great:
        return Colors.green;
    }
  }
}
