import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:frc_scouting/getx_screens/post_game_screen.dart';
import 'package:frc_scouting/services/event_key.dart';
import 'package:get/get.dart';

import '../getx_screens/home_screen.dart';
import 'documents_helper.dart';
import 'match_data.dart';

enum MatchListFilter { date, hasUploaded }

class BusinessLogicController extends GetxController {
  late EventKey selectedEvent;
  late MatchData matchData;
  final DocumentsHelper documentsHelper = DocumentsHelper();
  var matchFilterType = MatchListFilter.date.obs;

  @override
  void onInit() {
    selectedEvent = EventKey.chezyChamps2022;
    matchData = MatchData(eventKey: selectedEvent);

    super.onInit();
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

  bool isHeaderDataValid() {
    return matchData.scouterId.value != 0 &&
        matchData.matchNumber.value != 0 &&
        matchData.teamNumber.value != 0;
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
    matchData = MatchData(eventKey: selectedEvent);
    Get.offAll(() => HomeScreen());
  }

  Future<void> startGameScreenTimer() async {
    matchData.startTime = DateTime.now().millisecondsSinceEpoch;

    await Future.delayed(
      const Duration(seconds: 5),
      () => Get.to(
        PostGameScreen(),
      ),
    );
  }
}
