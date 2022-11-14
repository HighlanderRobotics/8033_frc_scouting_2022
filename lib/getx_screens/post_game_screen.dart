import 'package:flutter/material.dart';
import 'package:frc_scouting/custom_widgets/frc_app_bar.dart';
import 'package:frc_scouting/getx_screens/qrcode_screen.dart';
import 'package:get/get.dart';

import '../services/getx_business_logic.dart';

class PostGameScreen extends StatelessWidget {
  List<String> climbingChallenges = [
    "Didn't Climb",
    "Failed Climb",
    "Bottom Bar",
    "Middle Bar",
    "High Bar",
    "Traverse",
  ];

  final notesController = TextEditingController();

  final BusinessLogicController c = Get.find();

  var selectedDefenseRating = 0.obs;

  @override
  Widget build(BuildContext context) {
    c.resetOrientation();

    return Scaffold(
      appBar: scoutingAppBar("Post Game"),
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
                        maxLines: null,
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
          for (int radioNumber in [1, 2, 3, 4, 5])
            Column(
              children: [
                Radio(
                    value: radioNumber,
                    groupValue: selectedDefenseRating.value,
                    onChanged: (value) =>
                        selectedDefenseRating.value = radioNumber),
                Text("$radioNumber")
              ],
            ),
        ],
      ),
    );
  }

  DropdownButton<String> climbingChallengeDropdown() {
    return DropdownButton(
      items: [
        const DropdownMenuItem(
          value: "Climbing Challenge",
          child: Text(
            "Climbing Challenge",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        for (var challenge in climbingChallenges)
          DropdownMenuItem(
            value: challenge,
            child: Text(
              challenge,
            ),
          ),
      ],
      onChanged: (newValue) => c.updateClimbingChallenge(newValue as String),
      value: c.matchData.challengeResult.value,
    );
  }

  ElevatedButton showQrCodeButton() {
    return ElevatedButton(
      onPressed: c.matchData.challengeResult.value == "Climbing Challenge"
          ? null
          : () async {
              if (!c.isPostGameDataValid()) {
                Get.snackbar(
                  "Invalid Post Game Data",
                  "Please select a climbing challenge",
                  snackPosition: SnackPosition.BOTTOM,
                );
              } else {
                // I think it meant to be !=
                if (selectedDefenseRating.value != 0 && notesController.text.isNotEmpty) {
                  Get.to(() {
                    return QrCodeScreen(
                      matchQrCodes: c.separateEventsToQrCodes(c.matchData),
                      canGoBack: false,
                    );
                  });
                }
              }
            },
      child: const Text("Show QR Code"),
    );
  }
}
