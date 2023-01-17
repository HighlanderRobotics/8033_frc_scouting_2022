enum CompetitionKey { chezyChamps2022 }

extension CompetitionKeyExtension on CompetitionKey {
  String get stringValue {
    switch (this) {
      case CompetitionKey.chezyChamps2022:
        return 'Chezy Champs 2023';
    }
  }

  String get eventCode {
    switch (this) {
      case CompetitionKey.chezyChamps2022:
        return "2022cc";
    }
  }
}
