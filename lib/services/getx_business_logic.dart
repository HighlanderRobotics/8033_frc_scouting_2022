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

  @override
  void onInit() async {
    directory = await getApplicationDocumentsDirectory();
    super.onInit();
  }

  bool isHeaderDataValid() {
    return matchData.value.scouterId.value != 0 &&
        matchData.value.matchNumber.value != 0 &&
        matchData.value.teamNumber.value != 0;
  }

  void addEvent(Event event) {
    matchData.value.events.add(event);
  }

  void updateClimbingChallenge(String challenge) {
    if (challenge != "Climbing Challenge") {
      matchData.value.challengeResult.value = challenge;
    }
  }

  Future<void> saveMatchData(MatchData matchData) async {
    if (!(matchData.isSaved.value)) {
      await _writeToFile(matchData);
    }

    return;
  }

  Future<void> _writeToFile(MatchData matchData) async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path;

    var filePath = "$path/frc-${matchData.uuid}.json";
    print("Writing to file: $filePath");
    File file = File(filePath);
    file.writeAsString(jsonEncode(matchData.toJson()));
    print("Successfully wrote to file: $filePath");
  }

  List<FileSystemEntity> getFilesInDirectoryMask() {
    return directory.listSync().toList();
  }

  bool _isFileValid(File file) {
    return file.uri.pathSegments.last.substring(0, 4).contains("frc-");
  }

  MatchesFormat getMatches() {
    final List<FileSystemEntity> allFiles = getFilesInDirectoryMask();
    final List<File> files = allFiles.whereType<File>().toList();
    var matches = MatchesFormat([], 0);

    for (var file in files) {
      if (_isFileValid(file)) {
        final String contents = file.readAsStringSync();
        final MatchData match = MatchData.fromJson(jsonDecode(contents));
        matches.validMatches.add(match);
      } else {
        matches.numberOfInvalidFiles++;
      }
    }

    return matches;
  }

  List<String> separateEventsToQrCodes(MatchData matchData) {
    List<String> qrCodes = [];
    final numberOfQrCodes = (6900 / 3000).ceil();
    var jsonString = jsonEncode(matchData.toJson());
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

  void reset() {
    matchData.value = MatchData();
    Get.offAll(() => HomeScreen());
  }
}

class MatchesFormat {
  List<MatchData> validMatches;
  int numberOfInvalidFiles;

  MatchesFormat(this.validMatches, this.numberOfInvalidFiles);
}

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
