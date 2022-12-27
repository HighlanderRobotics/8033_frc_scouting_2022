import 'dart:math';

import '../climbing_challenge.dart';
import '../event_key.dart';
import '../event.dart';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../robot_roles.dart';

class MatchData {
  var uuid = const Uuid().v4();
  late Rx<CompetitionKey> competitionKey;
  var matchNumber = 0.obs;
  var teamNumber = 0.obs;
  var scouterId = 0.obs;
  var startTime = DateTime.now();
  var events = <Event>[].obs;
  var robotRole = RobotRole.offense.obs;
  var overallDefenseRating = 0.obs;
  var defenseFrequencyRating = 0.obs;
  var notes = "".obs;
  var challengeResult = ClimbingChallenge.didntClimb.obs;
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
      robotRole = RobotRole.values[(json['robotRole'])].obs;
      notes = RxString(json['notes']);
      challengeResult =
          ClimbingChallengeExtension.fromName(json['challengeResult']).obs;
      hasNotSavedToCloud = Random().nextBool().obs; // TODO: Implement this
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
        'robotRole': robotRole.value.index,
        'overallDefenseRating': overallDefenseRating.value,
        'defenseFrequencyRating': defenseFrequencyRating.value,
        'notes': notes.value,
        'challengeResult': challengeResult.value.name,
      };
}
