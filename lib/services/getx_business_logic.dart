import 'dart:io';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../getx_screens/home_screen.dart';
import 'event.dart';
import 'match_data.dart';
import 'previous_match.dart';

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

  bool isPostGameDataValid() =>
      matchData.value.challengeResult.value != "Climbing Challenge";

  void addEvent(Event event) {
    matchData.value.events.add(event);
  }

  void updateClimbingChallenge(String challenge) {
    if (challenge != "Climbing Challenge") {
      matchData.value.challengeResult.value = challenge;
    }
  }

  Future<void> saveMatchData(MatchData matchData) async {
    if (!matchData.isSaved.value) {
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

  MatchInfo getMatches() {
    final List<FileSystemEntity> allFiles = getFilesInDirectoryMask();
    final List<File> files = allFiles.whereType<File>().toList();
    var matches = MatchInfo([], 0);

    for (var file in files) {
      if (_isFileValid(file)) {
        final String contents = file.readAsStringSync();
        final MatchData match = MatchData.fromJson(jsonDecode(contents));
        matches.validMatches.add(match);
      } else if (!file.uri.pathSegments.last.startsWith(".")) {
        matches.numberOfInvalidFiles++;
      }
    }

    return matches;
  }

  List<String> separateEventsToQrCodes(MatchData matchData) {
    List<String> qrCodes = [];
    var jsonString = jsonEncode(matchData.toJson());
    const qrCodeLimit = 2500;

    print("jsonString length: ${jsonString.length}");

    while (jsonString.length > qrCodeLimit) {
      qrCodes.add(jsonString.substring(0, qrCodeLimit));
      jsonString = jsonString.replaceRange(0, qrCodeLimit, "");
    }

    qrCodes.add(jsonString);

    print("# of QrCodes: ${qrCodes.length}");

    return qrCodes;
  }

  void reset() {
    matchData = MatchData().obs;
    Get.offAll(() => HomeScreen());
  }
}
