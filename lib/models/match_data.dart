import 'package:frc_scouting/helpers/match_schedule_helper.dart';
import 'package:frc_scouting/models/match_key.dart';
import 'package:frc_scouting/models/match_type.dart';

import 'climbing_challenge.dart';
import 'event_key.dart';
import 'event.dart';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'robot_roles.dart';

class MatchData {
  var uuid = const Uuid().v4();
  late Rx<CompetitionKey> competitionKey;
  var matchKey =
      MatchKey(matchNumber: 0, matchType: MatchType.qualifierMatch).obs;
  var teamNumber = 0.obs;
  var scouterName = "".obs;
  var startTime = DateTime.now();
  var events = <Event>[].obs;
  var robotRole = RobotRole.offense.obs;
  var notes = "".obs;
  var autoChallengeResult = ClimbingChallenge.noClimb.obs;
  var challengeResult = ClimbingChallenge.noClimb.obs;
  var hasSavedToCloud = false.obs;

  String get key {
    if (matchKey != null.obs) {
      final match = MatchScheduleHelper.shared.matchSchedule
          .firstWhere((match) => match.matchKey == matchKey.value);
      return match.key;
    }

    return "";
  }

  MatchData({
    required CompetitionKey competitionKey,
  }) : competitionKey = competitionKey.obs;

  MatchData.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    competitionKey = json['competitionKey'].obs;
    matchKey = json['matchKey'].obs;
    teamNumber = json['teamNumber'].obs;
    scouterName = json['scouterName'].obs;
    startTime = DateTime.parse(json['startTime']);
    events = json['events'].map<Event>((e) => Event.fromJson(e)).toList().obs;
    robotRole = json['robotRole'].obs;
    notes = json['notes'].obs;
    autoChallengeResult = json['autoChallengeResult'].obs;
    challengeResult = json['challengeResult'].obs;
    hasSavedToCloud = json['hasSavedToCloud'].obs;
  }

  Map<String, dynamic> toJson({
    required bool includesCloudStatus,
  }) =>
      {
        'uuid': uuid,
        'competitionKey': competitionKey.value.eventCode,
        'matchKey': matchKey.value.shortMatchKey,
        'teamNumber': teamNumber.value,
        'scouterName': scouterName.value,
        'startTime': startTime.microsecondsSinceEpoch,
        'events': events.map((e) => e.toJson()).toList(),
        'robotRole': robotRole.value.index,
        'notes': notes.value,
        'autoChallengeResult': autoChallengeResult.value.index,
        'challengeResult': challengeResult.value.index,
        if (includesCloudStatus) 'hasSavedToCloud': hasSavedToCloud.isTrue,
      };
}
