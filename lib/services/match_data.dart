import 'package:frc_scouting/services/event_key.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'event.dart';

class MatchData {
  var uuid = const Uuid().v4();
  late Rx<EventKey> eventKey;
  var matchNumber = 0.obs;
  var teamNumber = 0.obs;
  var scouterId = 0.obs;
  var startTime = 0;
  var events = <Event>[].obs;
  var didDefense = false.obs;
  var notes = "".obs;
  var challengeResult = "Climbing Challenge".obs;
  var hasSavedToCloud = false.obs;

  MatchData({required EventKey eventKey}) : eventKey = eventKey.obs;

  MatchData.fromJson(Map<String, dynamic> json) {
    try {
      uuid = json['uuid'];
      eventKey = Rx(
          EventKey.values.firstWhere((e) => e.eventCode == json['eventKey']));
      matchNumber = RxInt(json['matchNumber']);
      teamNumber = RxInt(json['teamNumber']);
      scouterId = RxInt(json['scouterId']);
      startTime = json['startTime'];
      events =
          RxList(json['events'].map<Event>((e) => Event.fromJson(e)).toList());
      didDefense = RxBool(json['didDefense']);
      notes = RxString(json['notes']);
      challengeResult = RxString(json['challengeResult']);
      hasSavedToCloud = RxBool(json['hasSavedToCloud']);
    } on TypeError {
      throw Exception("Invalid JSON");
    }
  }

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'eventKey': eventKey.value.eventCode,
        'matchNumber': matchNumber.value,
        'teamNumber': teamNumber.value,
        'scouterId': scouterId.value,
        'startTime': startTime,
        'events': events.map((event) => event.toJson()).toList(),
        'notes': notes.value,
        'didDefense': didDefense.value,
        'challengeResult': challengeResult.value,
        'hasSavedToCloud': hasSavedToCloud.value,
      };
}
