import 'package:frc_scouting/services/game_screen_positions.dart';

import 'event_types.dart';

class Event {
  late int timeSince;
  late EventType type;
  late GameScreenPosition position;

  Event({required this.timeSince, required this.type, required this.position});

  Map<String, dynamic> toJson() => {
        'timeSince': timeSince,
        'type': type.toString(),
        'position': position.positionId,
      };

  Event.fromJson(Map<String, dynamic> json) {
    timeSince = json['timeSince'];
    type = EventType.values.firstWhere((e) => e.toString() == json['type']);
    position = GameScreenPositionHelper.fromPositionId(json['position']);
  }

  void printEvent() {
    print(
        'Event: $type, ${position}, ${timeSince}ms');
  }
}
