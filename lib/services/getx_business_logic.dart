import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../getx_screens/home_screen.dart';
import 'event_types.dart';

class BusinessLogicController extends GetxController {
  var matchData = MatchData().obs;

  void insertEvent(Event event) {
    matchData.value.events.insert(matchData.value.events.length, event);
  }

  void reset() {
    matchData.value = MatchData();
    Get.offAll(HomeScreen());
  }
}

class MatchData {
  var uuid = const Uuid().v4().obs;
  var matchNumber = 0;
  var teamNumber = 0;
  var scouterName = 0;
  var startTime = 0;
  var events = <Event>[].obs;
  var didDefense = false.obs;
  var notes = ''.obs;
  var challengeResult = ''.obs;

  String toJSONString() {
    return '{"uuid": "$uuid", "matchNumber": $matchNumber, "teamNumber": $teamNumber, "scouterName": "$scouterName", "startTime": $startTime, "events": ${events.map((e) => e.toJSONString()).toList()}, "didDefense": $didDefense, "notes": "$notes", "challengeResult": "$challengeResult"}';
  }

  List<String> separateEventsToQrCodes() {
    List<String> qrCodes = [];
    var numberOfQrCodes = (6900 / 3000).ceil();
    var jsonString = toJSONString();
    final qrCodeLimit = 2500;

    print("jsonString length: ${jsonString.length}");

    var counter = 0;

    while (jsonString.length > qrCodeLimit) {
      qrCodes.add(jsonString.substring(0, (counter + 1) * qrCodeLimit));
      jsonString = jsonString.replaceRange(0, (counter + 1) * qrCodeLimit, "");
      counter++;
    }

    qrCodes.add(jsonString);

    print("# of QrCodes: ${qrCodes.length}");

    return qrCodes;
  }
}

class Event {
  int timeSince;
  EventType type;
  int position;

  String toJSONString() {
    return '{"timeSince": $timeSince, "type": "$type", "position": $position}';
  }

  Event({required this.timeSince, required this.type, required this.position});
}

// enum ClimbingChallenge {
//   climbingChallenge,
//   didntClimb,
//   failedClimb,
//   bottomBar,
//   middleBar,
//   highBar,
//   traverse,
// }