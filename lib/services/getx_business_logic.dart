import 'dart:io';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../getx_screens/home_screen.dart';
import 'event_types.dart';

class BusinessLogicController extends GetxController {
  var matchData = MatchData().obs;
  late Directory directory;

  void onInit() async {
    directory = await getApplicationDocumentsDirectory();
    super.onInit();
  }

  void addEvent(Event event) {
    matchData.value.events.add(event);
  }

  void updateClimbingChallenge(String challenge) {
    if (challenge != "Climbing Challenge") {
      matchData.value.challengeResult.value = challenge;
    }
  }

  List<File> getFilesInDirectoryMask() {
    final List<FileSystemEntity> entities = directory.listSync().toList();
    return entities.whereType<File>().toList();
  }

  bool _isFileValid(File file) {
    return file.uri.pathSegments.last.substring(0, 4).contains("frc-");
  }

  List<MatchData> getMatches() {
    final List<File> files = getFilesInDirectoryMask();
    final List<MatchData> matches = [];

    for (var file in files) {
      if (_isFileValid(file)) {
        final String contents = file.readAsStringSync();
        final MatchData match = MatchData.fromJson(jsonDecode(contents));
        matches.add(match);
      }
    }

    return matches;
  }

  void reset() {
    matchData.value = MatchData();
    Get.offAll(() => HomeScreen());
  }
}

class MatchData {
  var uuid = const Uuid().v4();
  var matchNumber = 0;
  var teamNumber = 0;
  var scouterName = 0;
  var startTime = 0;
  var events = <Event>[].obs;
  var didDefense = false.obs;
  var notes = "".obs;
  var challengeResult = "Climbing Challenge".obs;
  var isSaved = false.obs;

  MatchData();

  MatchData.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    matchNumber = json['matchNumber'];
    teamNumber = json['teamNumber'];
    scouterName = json['scouterName'];
    startTime = json['startTime'];
    events =
        RxList(json['events'].map<Event>((e) => Event.fromJson(e)).toList());
    didDefense = RxBool(json['didDefense']);
    notes = RxString(json['notes']);
    challengeResult = RxString(json['challengeResult']);
  }

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'matchNumber': matchNumber,
        'teamNumber': teamNumber,
        'scouterName': scouterName,
        'startTime': startTime,
        'events': events.map((event) => event.toJson()).toList(),
        'notes': notes.value,
        'didDefense': didDefense.value,
        'challengeResult': challengeResult.value,
      };

  List<String> separateEventsToQrCodes() {
    List<String> qrCodes = [];
    final numberOfQrCodes = (6900 / 3000).ceil();
    var jsonString = jsonEncode(toJson());
    const qrCodeLimit = 2500;

    print("jsonString length: ${jsonString.length}");

    var counter = 0;

    while (jsonString.length > qrCodeLimit) {
      qrCodes.add(jsonString.substring(0, qrCodeLimit));
      jsonString = jsonString.replaceRange(0, qrCodeLimit, "");
      counter++;
    }

    qrCodes.add(jsonString);

    print("# of QrCodes: ${qrCodes.length}");

    return qrCodes;
  }

  Future<void> saveMatchData() async {
    if (!(isSaved.value)) {
      await _writeToFile();
    }

    return;
  }

  Future<void> _writeToFile() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path;

    var filePath = path + "/frc-$uuid.json";
    print("Writing to file: $filePath");
    File file = File(filePath);
    file.writeAsString(jsonEncode(toJson()));
    print("Successfully wrote to file: $filePath");
  }
}

class Event {
  var timeSince = 0;
  var type = EventType.shotSuccess;
  var position = 0;

  Event({required this.timeSince, required this.type, required this.position});

  Map<String, dynamic> toJson() => {
        'timeSince': timeSince,
        'type': type.toString(),
        'position': position,
      };

  Event.fromJson(Map<String, dynamic> json) {
    timeSince = json['timeSince'];
    type = EventType.values.firstWhere((e) => e.toString() == json['type']);
    position = json['position'];
  }
}

// extension ParseToString on Event {
//   String toShortString() {
//     return toString().split('.').last;
//   }
// }

// enum ClimbingChallenge {
//   climbingChallenge,
//   didntClimb,
//   failedClimb,
//   bottomBar,
//   middleBar,
//   highBar,
//   traverse
// }