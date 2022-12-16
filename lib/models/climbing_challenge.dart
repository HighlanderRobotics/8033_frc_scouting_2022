enum ClimbingChallenge {
  didntClimb,
  failedClimb,
  bottomBar,
  middleBar,
  highBar,
  traversal
}

extension ClimbingChallengeExtension on ClimbingChallenge {
  String get name {
    switch (this) {
      case ClimbingChallenge.didntClimb:
        return "Didn't climb";
      case ClimbingChallenge.failedClimb:
        return "Failed climb";
      case ClimbingChallenge.bottomBar:
        return "Bottom bar";
      case ClimbingChallenge.middleBar:
        return "Middle bar";
      case ClimbingChallenge.highBar:
        return "High bar";
      case ClimbingChallenge.traversal:
        return "Traversal";
      default:
        return "Unknown";
    }
  }

  static ClimbingChallenge fromName(String name) {
    switch (name) {
      case "Didn't climb":
        return ClimbingChallenge.didntClimb;
      case "Failed climb":
        return ClimbingChallenge.failedClimb;
      case "Bottom bar":
        return ClimbingChallenge.bottomBar;
      case "Middle bar":
        return ClimbingChallenge.middleBar;
      case "High bar":
        return ClimbingChallenge.highBar;
      case "Traversal":
        return ClimbingChallenge.traversal;
      default:
        return ClimbingChallenge.didntClimb;
    }
  }
}
