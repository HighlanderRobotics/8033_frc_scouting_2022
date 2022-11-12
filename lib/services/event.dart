import 'event_types.dart';

class Event {
  late int timeSince;
  late EventType type;
  late int position;

  Event({required this.timeSince, required this.type, required this.position});

  Map<String, dynamic> toJson() => {
        'timeSince': timeSince,
        'type': type.toString(),
        'position': position,
      };

  Event.fromJson(Map<String, dynamic> json) {
    timeSince = json['timeSince'];
    type = EventType.values.firstWhere((e) => e.toString() == json['type']);
    position = json['position'];
  }

  void printEvent() {
    print('Event: $type, $position, ${timeSince}ms');
  }
}
