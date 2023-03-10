enum GameConfigurationRotation { upright, upsideDown }

extension RotationExtension on GameConfigurationRotation {
  String get localizedDescription {
    switch (this) {
      case GameConfigurationRotation.upright:
        return "Upright";
      case GameConfigurationRotation.upsideDown:
        return "Upside Down";
    }
  }

  GameConfigurationRotation getToggledValue() {
    switch (this) {
      case GameConfigurationRotation.upright:
        return GameConfigurationRotation.upsideDown;
      case GameConfigurationRotation.upsideDown:
        return GameConfigurationRotation.upright;
    }
  }
}
