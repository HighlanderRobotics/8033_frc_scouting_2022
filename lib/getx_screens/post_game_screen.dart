import 'package:flutter/material.dart';
import 'package:frc_scouting/getx_screens/view_qrcode_screen.dart';
import 'package:frc_scouting/services/climbing_challenge.dart';
import 'package:get/get.dart';

import '../services/getx_business_logic.dart';

class PostGameScreen extends StatelessWidget {
  List<ClimbingChallenge> climbingChallenges = [
    ClimbingChallenge.didntClimb,
    ClimbingChallenge.failedClimb,
    ClimbingChallenge.bottomBar,
    ClimbingChallenge.middleBar,
    ClimbingChallenge.highBar,
    ClimbingChallenge.traversal,
  ];

  final notesController = TextEditingController();

  final BusinessLogicController controller = Get.find();

  var selectedDefenseRating = "None".obs;

  @override
  Widget build(BuildContext context) {
    controller.resetOrientation();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Post Game"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: Obx(
            (() => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Select Climbing Challenge",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    climbingChallengeDropdown(),
                    const Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Defense Rating",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    defenseRatingRadioButtons(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Get.mediaQuery.size.width * 0.03),
                      child: TextField(
                        decoration: const InputDecoration(hintText: "Notes"),
                        maxLines: 3,
                        controller: notesController,
                      ),
                    ),
                    showQrCodeButton(),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  Padding defenseRatingRadioButtons() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (String radioElement in ["None", "1", "2", "3", "4", "5"])
            Column(
              children: [
                Radio(
                    value: radioElement,
                    groupValue: selectedDefenseRating.value,
                    onChanged: (value) =>
                        selectedDefenseRating.value = radioElement),
                Text(radioElement)
              ],
            ),
        ],
      ),
    );
  }

  DropdownButton<String> climbingChallengeDropdown() {
    return DropdownButton(
      items: [
        for (var challenge in climbingChallenges)
          DropdownMenuItem(
            value: challenge.name,
            child: Text(
              challenge.name,
            ),
          ),
      ],
      onChanged: (newValue) => controller.matchData.challengeResult.value =
          ClimbingChallengeExtension.fromName(
              newValue ?? ClimbingChallenge.didntClimb.name),
      value: controller.matchData.challengeResult.value.name,
    );
  }

  ElevatedButton showQrCodeButton() {
    return ElevatedButton(
      onPressed: () async {
        // if (!controller.isPostGameDataValid()) {
        //   Get.snackbar(
        //     "Invalid Post Game Data",
        //     "Please select a climbing challenge",
        //     snackPosition: SnackPosition.BOTTOM,
        //   );
        // } else {
        if (await controller.documentsHelper
            .saveMatchData(controller.matchData)) {
          Get.snackbar(
            "Upload Successful",
            "Match has uploaded to cloud",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
        Get.to(() {
          return QrCodeScreen(
            matchQrCodes:
                controller.separateEventsToQrCodes(controller.matchData),
            canGoBack: false,
          );
        });
        // }
      },
      child: const Text("Show QR Code"),
    );
  }
}
