enum ClimbingChallenge { noClimb, supported, charged, failed, inCommunity }

extension ClimbingChallengeExtension on ClimbingChallenge {
  String get localizedDescription {
    switch (this) {
      case ClimbingChallenge.noClimb:
        return "No Climb";
      case ClimbingChallenge.supported:
        return "Supported";
      case ClimbingChallenge.charged:
        return "Charged";
      case ClimbingChallenge.failed:
        return "Failed";
      case ClimbingChallenge.inCommunity:
        return "In Community";
      default:
        return "Unknown";
    }
  }
}
