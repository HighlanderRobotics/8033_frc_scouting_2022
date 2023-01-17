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

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      timeSince: json['timeSince'],
      action: RobotAction.values[json['action']],
      position: json['position'],
    );
  }

  Map<String, dynamic> toJson() => {
        'timeSince': timeSince,
        'action': action.index,
        'position': position,
      };

  void debugLogDescription() {
    print(
        "timeSince: $timeSince, action: ${action.index}, position: $position");
  }
}
