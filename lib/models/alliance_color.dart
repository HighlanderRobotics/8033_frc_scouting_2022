enum AllianceColor { red, blue }

extension AllianceColorName on AllianceColor {
  String get localizedDescription {
    switch (this) {
      case AllianceColor.red:
        return 'Red';
      case AllianceColor.blue:
        return 'Blue';
    }
  }
}
