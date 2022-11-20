import 'dart:math';

import 'package:frc_scouting/services/event_key.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'event.dart';

class MatchData {
  var uuid = const Uuid().v4();
  late Rx<CompetitionKey> competitionKey;
  var matchNumber = 0.obs;
  var teamNumber = 0.obs;
  var scouterId = 0.obs;
  var startTime = DateTime.now();
  var events = <Event>[].obs;
  var didDefense = false.obs;
  var notes = "".obs;
  var challengeResult = "Climbing Challenge".obs;
  var hasNotSavedToCloud = false.obs;

  MatchData({required CompetitionKey competitionKey})
      : competitionKey = competitionKey.obs;

  MatchData.fromJson(Map<String, dynamic> json) {
    try {
      uuid = json['uuid'];
      competitionKey = Rx(CompetitionKey.values
          .firstWhere((e) => e.eventCode == json['competitionKey']));
      matchNumber = RxInt(json['matchNumber']);
      teamNumber = RxInt(json['teamNumber']);
      scouterId = RxInt(json['scouterId']);
      startTime = DateTime.fromMillisecondsSinceEpoch(json['startTime']);
      events =
          RxList(json['events'].map<Event>((e) => Event.fromJson(e)).toList());
      didDefense = RxBool(json['didDefense']);
      notes = RxString(json['notes']);
      challengeResult = RxString(json['challengeResult']);
      hasNotSavedToCloud = Random().nextBool().obs;
      // TODO: Implement this
    } on TypeError {
      throw Exception("Invalid JSON");
    }
  }

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'competitionKey': competitionKey.value.eventCode,
        'matchNumber': matchNumber.value,
        'teamNumber': teamNumber.value,
        'scouterId': scouterId.value,
        'startTime': startTime.millisecondsSinceEpoch,
        'events': events.map((event) => event.toJson()).toList(),
        'notes': notes.value,
        'didDefense': didDefense.value,
        'challengeResult': challengeResult.value,
        'hasNotSavedToCloud': hasNotSavedToCloud.value,
      };
}
