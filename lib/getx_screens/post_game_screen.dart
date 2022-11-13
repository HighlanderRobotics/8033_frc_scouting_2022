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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Select Climbing Challenge",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Obx(
              () => DropdownButton(
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
                onChanged: (newValue) =>
                    c.updateClimbingChallenge(newValue as String),
                value: c.matchData.challengeResult.value,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                "Defense Rating",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int radioNumber in [1, 2, 3, 4, 5])
                    Obx(
                      () => Column(
                        children: [
                          Radio(
                              value: radioNumber,
                              groupValue: selectedDefenseRating.value,
                              onChanged: (value) =>
                                  selectedDefenseRating.value = radioNumber),
                          Text("$radioNumber")
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Obx(
              () => ElevatedButton(
                // not sure why this is happening
                // ignore: unrelated_type_equality_checks
                onPressed: c.matchData.challengeResult == "Climbing Challenge"
                    ? null
                    : () async {
                        if (!c.isPostGameDataValid()) {
                          Get.snackbar(
                            "Invalid Post Game Data",
                            "Please select a climbing challenge",
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        } else {
                          if (await c.documentsHelper
                              .saveMatchData(c.matchData)) {
                            Get.snackbar(
                              "Upload Successful",
                              "Match has uploaded to cloud",
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }

                          Get.to(() {
                            return QrCodeScreen(
                              matchQrCodes:
                                  c.separateEventsToQrCodes(c.matchData),
                              canGoBack: false,
                            );
                          });
                        }
                      },
                child: const Text("Show QR Code"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
