enum TournamentKey { chezyChamps2022 }

extension TournamentKeyExtension on TournamentKey {
  String get stringValue {
    switch (this) {
      case TournamentKey.chezyChamps2022:
        return 'Chezy Champs 2022';
    }
  }

  String get eventCode {
    switch (this) {
      case TournamentKey.chezyChamps2022:
        return "2022cc";
    }
  }
}
