import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frc_scouting/getx_screens/post_game_screen.dart';
import 'package:frc_scouting/models/event_key.dart';
import 'package:frc_scouting/models/game_screen_positions.dart';
import '../networking/the_blue_alliance_api.dart';
import 'package:get/get.dart';

import '../getx_screens/home_screen.dart';
import '../persistence/documents_helper.dart';
import '../models/event.dart';
import '../models/event_types.dart';
import '../models/match_data/match_data.dart';
import '../helpers/scouters_helper.dart';

enum MatchFilterType { date, hasNotUploaded }

extension MatchFilterTypeExtension on MatchFilterType {
  String get name {
    switch (this) {
      case MatchFilterType.date:
        return "Date";
      case MatchFilterType.hasNotUploaded:
        return "Not Uploaded";
      default:
        return "Unknown";
    }
  }
}

class BusinessLogicController extends GetxController {
  late CompetitionKey selectedEvent;
  late MatchData matchData;
  final DocumentsHelper documentsHelper = DocumentsHelper();
  var matchFilterType = MatchFilterType.date.obs;
  final scoutersHelper = ScoutersHelper();
  RxList<List<int>> eventSchedule = RxList<List<int>>([]);

  var selectedScouterId = RxInt(-1);
  var selectedScouterQrCodeId = RxInt(-1);

  @override
  void onInit() async {
    selectedEvent = CompetitionKey.chezyChamps2022;
    matchData = MatchData(competitionKey: selectedEvent);
    await scoutersHelper.getAllScouters();

    eventSchedule.value =
        await TheBlueAllianceAPI().getMatchSchedule(selectedEvent.eventCode);

    super.onInit();
  }

  Orientation get currentOrientation {
    return Get.mediaQuery.orientation;
  }

  void setPortraitOrientation() {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
  }

  void setLandscapeOrientation() {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
    );
  }

  void resetOrientation() {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
  }

  bool isHeaderDataValid(int selectedScouterId) {
    return matchData.matchNumber.value != 0 &&
        matchData.teamNumber.value != 0 &&
        selectedScouterId != -1;
  }

  void addEvent(EventType eventType, GameScreenPosition position) {
    final event = Event(
        timeSince: DateTime.now().millisecondsSinceEpoch -
            matchData.startTime.millisecondsSinceEpoch,
        type: eventType,
        position: position);
    matchData.events.add(event);
    event.printEvent();
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
    matchData = MatchData(competitionKey: selectedEvent);
    Get.offAll(() => HomeScreen());
  }

  Future<void> startGameScreenTimer() async {
    matchData.startTime = DateTime.now();

    await Future.delayed(
      const Duration(seconds: 125),
      () => Get.to(
        PostGameScreen(),
      ),
    );
  }
}
