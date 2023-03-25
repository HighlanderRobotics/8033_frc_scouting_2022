enum Alliance { red, blue }

extension AllianceName on Alliance {
  String get localizedDescription {
    switch (this) {
      case Alliance.red:
        return 'Red';
      case Alliance.blue:
        return 'Blue';
    }
  }
}
