import 'dart:convert';

import 'package:frc_scouting/getx_screens/post_game_screen.dart';
import 'package:get/get.dart';

import '../getx_screens/home_screen.dart';
import 'documents_helper.dart';
import 'event.dart';
import 'match_data.dart';

class BusinessLogicController extends GetxController {
  var matchData = MatchData().obs;
  final DocumentsHelper documentsHelper = DocumentsHelper();

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

  Future<void> startGameScreenTimer() async {
    await Future.delayed(
      const Duration(seconds: 5),
      () => Get.to(
        PostGameScreen(),
      ),
    );
  }
}
