import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:path_provider/path_provider.dart';

import '../../models/match_data/match_data.dart';
import '../models/previous_matches_info.dart';

class FilesHelper {
  late Directory directory;

  FilesHelper() {
    getApplicationDocumentsDirectory().then((value) => directory = value);
  }

  Future<bool> saveMatchData(MatchData matchData) async {
    await _writeToFile(matchData);

    // TODO: try to upload to Server?

    // TODO: Get saved statuses from server
    matchData.hasNotSavedToCloud.value = Random().nextBool();

    return matchData.hasNotSavedToCloud.value;
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

  PreviousMatchesInfo getPreviousMatches() {
    final List<FileSystemEntity> allFiles = getFilesInDirectoryMask();
    final List<File> files = allFiles.whereType<File>().toList();
    var matches = PreviousMatchesInfo([], 0);

    for (var file in files) {
      if (_isFileValid(file)) {
        final String contents = file.readAsStringSync();
        try {
          final MatchData match = MatchData.fromJson(jsonDecode(contents));
          matches.validMatches.add(match);
        } catch (_) {
          print(
              "Error parsing file: ${file.uri.pathSegments.last} Invalid Format");
          matches.numberOfInvalidFiles++;
        }
      } else if (!file.uri.pathSegments.last.startsWith(".")) {
        matches.numberOfInvalidFiles++;
      }
    }

    return matches;
  }

  Future<void> deleteFile(String uuid) async {
    String path = directory.path;

    var filePath = "$path/frc-$uuid.json";

    try {
      final file = await File(filePath).delete();
      print("Successfully deleted file: ${file.path}");
    } catch (e) {
      print("Error deleting file: $filePath");
    }
  }

  List<String> getPreviousMatchUUIDs() {
    List<String> previousMatchUUIDs = [];

    final List<FileSystemEntity> allFiles = getFilesInDirectoryMask();
    final List<File> files = allFiles.whereType<File>().toList();

    for (var file in files) {
      if (_isFileValid(file)) {
        previousMatchUUIDs.add(file.uri.pathSegments.last
            .substring(5, file.uri.pathSegments.last.length - 1));
      }
    }

    return previousMatchUUIDs;
  }
}
