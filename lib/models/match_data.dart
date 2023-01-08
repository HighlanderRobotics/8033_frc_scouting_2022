import 'dart:math';

import 'package:frc_scouting/helpers/match_schedule_helper.dart';
import 'package:frc_scouting/models/match_key.dart';

import 'climbing_challenge.dart';
import 'event_key.dart';
import 'event.dart';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'robot_roles.dart';

class MatchData {
  var uuid = const Uuid().v4();
  late Rx<CompetitionKey> competitionKey;
  Rx<MatchKey?> matchKey = null.obs;
  var teamNumber = 0.obs;
  var scouterName = "".obs;
  var startTime = DateTime.now();
  var events = <Event>[].obs;
  var robotRole = RobotRole.offense.obs;
  var overallDefenseRating = 0.obs;
  var defenseFrequencyRating = 0.obs;
  var notes = "".obs;
  var challengeResult = ClimbingChallenge.didntClimb.obs;
  var hasSavedToCloud = false.obs;

  String get key {
    if (matchKey != null.obs) {
      final match = MatchScheduleHelper.shared.matchSchedule
          .firstWhere((match) => match.matchKey == matchKey.value);
      return match.key;
    }
    return "";
  }

  MatchData({required CompetitionKey competitionKey})
      : competitionKey = competitionKey.obs;

  MatchData.fromJson(Map<String, dynamic> json) {
    try {
      uuid = json['uuid'];
      competitionKey = CompetitionKey.values
          .firstWhere((e) => e.eventCode == json['competitionKey'])
          .obs;
      matchKey = MatchKey.fromJsonUsingShortKeyForm(json['matchKey']).obs;
      teamNumber = json['teamNumber'].obs;
      scouterName = json['scouterName'].obs;
      startTime = DateTime.fromMillisecondsSinceEpoch(json['startTime']);
      events = json['events'].map<Event>((e) => Event.fromJson(e)).toList().obs;
      robotRole = RobotRole.values[(json['robotRole'])].obs;
      notes = RxString(json['notes']);
      challengeResult = ClimbingChallenge.values[json['challengeResult']].obs;
      hasSavedToCloud = json["hasSavedToCloud"].obs ?? false.obs;
    } on TypeError {
      throw Exception("Invalid JSON");
    }
  }

  Map<String, dynamic> toJson({required bool includesCloudStatus}) => {
        'uuid': uuid,
        'competitionKey': competitionKey.value.eventCode,
        'matchKey': matchKey.value?.shortMatchKey,
        'teamNumber': teamNumber.value,
        'scouterName': scouterName.value,
        'startTime': startTime.millisecondsSinceEpoch,
        'events': events.map((event) => event.toJson()).toList(),
        'robotRole': robotRole.value.index,
        'overallDefenseRating': overallDefenseRating.value,
        'defenseFrequencyRating': defenseFrequencyRating.value,
        'notes': notes.value,
        'challengeResult': challengeResult.value.index,
        if (includesCloudStatus) 'hasSavedToCloud': hasSavedToCloud.value,
      };
}
