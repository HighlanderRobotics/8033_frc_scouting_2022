enum GameScreenPosition { hub, tarmac, launchpad, fieldEnd, field, none }

extension GameScreenPositionHelper on GameScreenPosition {
  int get positionId {
    switch (this) {
      case GameScreenPosition.hub:
        return 0;
      case GameScreenPosition.tarmac:
        return 1;
      case GameScreenPosition.launchpad:
        return 2;
      case GameScreenPosition.fieldEnd:
        return 3;
      case GameScreenPosition.field:
        return 4;
      case GameScreenPosition.none:
        return 5;
    }
  }

  static GameScreenPosition fromPositionId(int id) {
    switch (id) {
      case 0:
        return GameScreenPosition.hub;
      case 1:
        return GameScreenPosition.tarmac;
      case 2:
        return GameScreenPosition.launchpad;
      case 3:
        return GameScreenPosition.fieldEnd;
      case 4:
        return GameScreenPosition.field;
      case 5:
        return GameScreenPosition.none;
      default:
        return GameScreenPosition.none;
    }
  }
}
