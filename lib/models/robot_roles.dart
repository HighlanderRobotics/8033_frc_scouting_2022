enum RobotRole { offense, defense, mixed, feeder }

extension RobotRoleExtension on RobotRole {
  String get localizedDescription {
    switch (this) {
      case RobotRole.offense:
        return "Offense";
      case RobotRole.defense:
        return "Defense";
      case RobotRole.mixed:
        return "Mixed";
      case RobotRole.feeder:
        return "Feeder";
    }
  }
}
