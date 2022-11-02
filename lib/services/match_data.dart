import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'event.dart';

class MatchData {
  var uuid = const Uuid().v4();
  var matchNumber = 0.obs;
  var teamNumber = 0.obs;
  var scouterId = 0.obs;
  var startTime = 0;
  var events = <Event>[].obs;
  var didDefense = false.obs;
  var notes = "".obs;
  var challengeResult = "Climbing Challenge".obs;
  var isSaved = false.obs;

  MatchData();

  MatchData.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    matchNumber = RxInt(json['matchNumber']);
    teamNumber = RxInt(json['teamNumber']);
    scouterId = RxInt(json['scouterId']);
    startTime = json['startTime'];
    events =
        RxList(json['events'].map<Event>((e) => Event.fromJson(e)).toList());
    didDefense = RxBool(json['didDefense']);
    notes = RxString(json['notes']);
    challengeResult = RxString(json['challengeResult']);
  }

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'matchNumber': matchNumber.value,
        'teamNumber': teamNumber.value,
        'scouterId': scouterId.value,
        'startTime': startTime,
        'events': events.map((event) => event.toJson()).toList(),
        'notes': notes.value,
        'didDefense': didDefense.value,
        'challengeResult': challengeResult.value,
      };
}
