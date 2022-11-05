enum EventKey {
  chezyChamps2022,
}

extension EventKeyExtension on EventKey {
  String get stringValue {
    switch (this) {
      case EventKey.chezyChamps2022:
        return 'Chezy Champs 2022';
    }
  }

  String get eventCode {
    switch (this) {
      case EventKey.chezyChamps2022:
        return "2022cc";
    }
  }
}

List<EventKey> eventKeys = [
  EventKey.chezyChamps2022,
];
