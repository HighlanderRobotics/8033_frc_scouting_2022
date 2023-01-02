enum RobotRole {
  offense,
  defense,
  mix,
}

extension RobotRoleExtension on RobotRole {
  String get localizedDescription {
    switch (this) {
      case RobotRole.offense:
        return "Offense";
      case RobotRole.defense:
        return "Defense";
      case RobotRole.mix:
        return "Mix";
    }
  }
}
