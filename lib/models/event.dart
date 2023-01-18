import 'robot_action.dart';

class Event {
  int timeSince;
  RobotAction action;
  int position;

  Event({
    required this.timeSince,
    required this.action,
    required this.position,
  });

  factory Event.fromJson(List<dynamic> json) {
    return Event(
      timeSince: json[0],
      action: RobotAction.values[1],
      position: json[2],
    );
  }

  List<dynamic> toJson() => [
        timeSince,
        action.index,
        position,
      ];

  void debugLogDescription() {
    print(
        "timeSince: $timeSince, action: ${action.index}, position: $position");
  }
}
