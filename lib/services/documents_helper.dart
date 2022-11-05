import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'match_data.dart';
import 'previous_match.dart';

class DocumentsHelper {
  late Directory directory;

  DocumentsHelper() {
    getApplicationDocumentsDirectory().then((value) => directory = value);
  }

  Future<bool> saveMatchData(MatchData matchData) async {
    await _writeToFile(matchData);

    // TODO: try to upload to Firebase

    matchData.hasSavedToCloud.value = true;

    return matchData.hasSavedToCloud.value;
    // return true;
  }

  Future<void> _writeToFile(MatchData matchData) async {
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
}
