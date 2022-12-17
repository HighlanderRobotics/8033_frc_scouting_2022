import 'package:frc_scouting/models/game_screen_positions.dart';

import 'event_types.dart';

class Event {
  late int timeSince;
  late EventType type;
  late GameScreenPosition position;

  Event({required this.timeSince, required this.type, required this.position});

  List<dynamic> toJson() => [timeSince, type.numericalValue, position.index];

  Event.fromJson(List<dynamic> json) {
    timeSince = json[0];
    type = EventType.values[1];
    position = GameScreenPosition.values[(json[2])];
  }

  void printEvent() {
    print('Event: $type, $position, ${timeSince}ms');
  }
}
