enum ClimbingChallenge { noClimb, docked, engaged, failed, inCommunity }

extension ClimbingChallengeExtension on ClimbingChallenge {
  String get localizedDescription {
    switch (this) {
      case ClimbingChallenge.noClimb:
        return "No Climb";
      case ClimbingChallenge.docked:
        return "Docked";
      case ClimbingChallenge.engaged:
        return "Engaged";
      case ClimbingChallenge.failed:
        return "Failed";
      case ClimbingChallenge.inCommunity:
        return "In Community";
      default:
        return "Unknown";
    }
  }

  String get longLocalizedDescription {
    switch (this) {
      case ClimbingChallenge.noClimb:
        return "Did not attempt to climb";
      case ClimbingChallenge.docked:
        return "The robot is securely attached to the Charge Station and is not touching any other part of the field";
      case ClimbingChallenge.engaged:
        return "The robot is securely attached to the Charge Station and is touching another part of the field.";
      case ClimbingChallenge.failed:
        return "The robot was attempting to Dock or Engage with the Charge Station but was unsuccessful";
      case ClimbingChallenge.inCommunity:
        return "The robot did not attempt to climb, but still was in the community";
      default:
        return "Unknown";
    }
  }
}
