import 'event_types.dart';

class Event {
  var timeSince = 0;
  var type = EventType.shotSuccess;
  var position = 0;

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
}
