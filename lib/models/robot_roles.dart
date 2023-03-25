enum RobotRole { offense, defense, feeder, immobile }

extension RobotRoleExtension on RobotRole {
  String get localizedDescription {
    switch (this) {
      case RobotRole.offense:
        return "Offense";
      case RobotRole.defense:
        return "Defense";
      case RobotRole.feeder:
        return "Feeder";
      case RobotRole.immobile:
        return "Immobile";
    }
  }

  String get longLocalizedDescription {
    switch (this) {
      case RobotRole.offense:
        return "This robot is designed to score points on the opponent's side of the field.";
      case RobotRole.defense:
        return "This robot is designed to prevent the opponent from scoring points on their side of the field.";
      case RobotRole.feeder:
        return "This robot is designed to feed power cells to other robots.";
      case RobotRole.immobile:
        return "The robot did not move for more than half of the match";
    }
  }
}
