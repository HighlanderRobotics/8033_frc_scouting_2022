import 'package:frc_scouting/getx_screens/settings_screen.dart';
import 'package:frc_scouting/helpers/match_schedule_helper.dart';
import 'package:frc_scouting/models/constants.dart';
import 'package:frc_scouting/models/match_key.dart';
import 'package:frc_scouting/models/match_type.dart';
import 'package:frc_scouting/models/tournament_key.dart';

import 'climbing_challenge.dart';
import 'event.dart';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'robot_roles.dart';

class MatchData {
  var uuid = const Uuid().v4();
  var matchKey = MatchKey(
    ordinalMatchNumber: 0,
    matchType: MatchType.qualifierMatch,
    rawShortMatchKey: "",
  ).obs;
  var teamNumber = 0.obs;
  var scouterName = "".obs;
  var startTime = DateTime.now();
  var events = <Event>[].obs;
  var robotRole = RobotRole.offense.obs;
  var notes = "".obs;
  var autoChallengeResult = ClimbingChallenge.noClimb.obs;
  var challengeResult = ClimbingChallenge.noClimb.obs;
  var hasSavedToCloud = false.obs;
  var tournamentKey = TournamentKey("", "");

  String get tbaKey {
    if (matchKey != null.obs) {
      final match = MatchScheduleHelper.shared.matchSchedule
          .firstWhereOrNull((match) => match.matchKey == matchKey.value);
      if (match != null) {
        final rawKey = match.key.substring(tournamentKey.key.length + 1);
        return rawKey.substring(0, rawKey.length - 2);
      }
    }

    return matchKey.value.shortMatchKey;
  }

  bool get isPreliminaryDataValid {
    return teamNumber.value != 0 &&
        scouterName.value != "" &&
        matchKey.value.ordinalMatchNumber != 0;
  }

  MatchData();

  MatchData.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    tournamentKey = TournamentKey.fromJson(json['tournamentKey']);
    matchKey = MatchKey.fromJsonUsingShortKeyForm(json['matchKey']).obs;
    teamNumber = RxInt(json['teamNumber']);
    scouterName = RxString(json['scouterName']);
    startTime = DateTime.fromMillisecondsSinceEpoch(json['startTime']);
    events =
        RxList(json['events'].map<Event>((e) => Event.fromJson(e)).toList());
    robotRole = RobotRole.values[json['robotRole']].obs;
    notes = RxString(json['notes']);
    autoChallengeResult =
        ClimbingChallenge.values[json['autoChallengeResult']].obs;
    challengeResult = ClimbingChallenge.values[json['challengeResult']].obs;

    if (json.containsKey("hasSavedToCloud")) {
      hasSavedToCloud = RxBool(json['hasSavedToCloud']);
    } else {
      hasSavedToCloud = false.obs;
    }
  }

  Map<String, dynamic> toJson({
    required bool includeUploadStatus,
    required bool usesTBAKey,
  }) =>
      {
        'uuid': uuid,
        'tournamentKey': tournamentKey,
        if (usesTBAKey)
          'matchKey': tbaKey
        else
          'matchKey': matchKey.value.shortMatchKey,
        'teamNumber': teamNumber.value,
        'scouterName': scouterName.value,
        'startTime': startTime.millisecondsSinceEpoch,
        'events': events.map((e) => e.toJson()).toList(),
        'robotRole': robotRole.value.index,
        'notes': notes.value,
        'autoChallengeResult': autoChallengeResult.value.index,
        'challengeResult': challengeResult.value.index,
        if (includeUploadStatus) 'hasSavedToCloud': hasSavedToCloud.isTrue,
      };
}
