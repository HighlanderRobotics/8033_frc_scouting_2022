import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frc_scouting/getx_screens/post_game_screen.dart';
import 'package:frc_scouting/services/event_key.dart';
import 'package:frc_scouting/services/game_screen_positions.dart';
import 'package:get/get.dart';

import '../getx_screens/home_screen.dart';
import 'documents_helper.dart';
import 'event.dart';
import 'event_types.dart';
import 'match_data.dart';
import 'scouters_helper.dart';

enum MatchListFilter { date, hasUploaded }

class BusinessLogicController extends GetxController {
  late CompetitionKey selectedEvent;
  late MatchData matchData;
  final DocumentsHelper documentsHelper = DocumentsHelper();
  var matchFilterType = MatchListFilter.date.obs;
  final scoutersHelper = ScoutersHelper();

  @override
  void onInit() async {
    selectedEvent = CompetitionKey.chezyChamps2022;
    matchData = MatchData(competitionKey: selectedEvent);
    await scoutersHelper.getAllScouters();

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
        timeSince: DateTime.now().millisecondsSinceEpoch - matchData.startTime,
        type: eventType,
        position: position);
    matchData.events.add(event);
    event.printEvent();
  }

  bool isPostGameDataValid() =>
      matchData.challengeResult.value != "Climbing Challenge";

  void updateClimbingChallenge(String challenge) {
    if (challenge != "Climbing Challenge") {
      matchData.challengeResult.value = challenge;
    }
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
    matchData.startTime = DateTime.now().millisecondsSinceEpoch;

    await Future.delayed(
      const Duration(seconds: 125),
      () => Get.to(
        PostGameScreen(),
      ),
    );
  }
}
