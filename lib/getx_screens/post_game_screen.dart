import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frc_scouting/getx_screens/view_qrcode_screen.dart';
import 'package:frc_scouting/models/climbing_challenge.dart';
import 'package:frc_scouting/models/robot_roles.dart';
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        climbingChallengeDropdown(),
                        const SizedBox(width: 20),
                        roleDropdownButton(),
                      ],
                    ),
                    if (controller.matchData.robotRole.value ==
                            RobotRole.defense ||
                        controller.matchData.robotRole.value == RobotRole.mix)
                      defenseRatingRadioButtons(),
                    TextField(
                      decoration: const InputDecoration(hintText: "Notes"),
                      controller: notesController,
                      onChanged: (value) =>
                          controller.matchData.notes.value = value,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: showQrCodeButton(),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  Widget roleDropdownButton() {
    return Obx(() => DropdownButton(
          items: [
            for (var role in [
              RobotRole.offense,
              RobotRole.defense,
              RobotRole.mix
            ])
              DropdownMenuItem(
                value: role,
                child: Text(role.localizedDescription),
                onTap: () => controller.matchData.robotRole.value = role,
              ),
          ],
          onChanged: (newValue) {
            if (newValue is RobotRole) {
              controller.matchData.robotRole.value = newValue;
            }

            if (newValue == RobotRole.offense) {
              controller.matchData.overallDefenseRating.value = 0;
              controller.matchData.defenseFrequencyRating.value = 0;
            }
          },
          value: controller.matchData.robotRole.value,
        ));
  }

  Padding defenseRatingRadioButtons() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Overall Defense",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            SizedBox(
              height: 100,
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 1,
                crossAxisCount: 5,
                children: [
                  for (int radioElement in [1, 2, 3, 4, 5])
                    Column(
                      children: [
                        Radio(
                            value: radioElement,
                            groupValue:
                                controller.matchData.overallDefenseRating.value,
                            onChanged: (value) => controller.matchData
                                .overallDefenseRating.value = value as int),
                        Text("$radioElement"),
                      ],
                    ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Defense Frequency",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            SizedBox(
              height: 70,
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 1,
                crossAxisCount: 5,
                children: [
                  for (int radioElement in [1, 2, 3, 4, 5])
                    Column(
                      children: [
                        Radio(
                            value: radioElement,
                            groupValue: controller
                                .matchData.defenseFrequencyRating.value,
                            onChanged: (value) => controller.matchData
                                .defenseFrequencyRating.value = value as int),
                        Text("$radioElement")
                      ],
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  DropdownButton<String> climbingChallengeDropdown() {
    return DropdownButton(
      items: [
        for (var challenge in climbingChallenges)
          DropdownMenuItem(
            value: challenge.localizedDescription,
            child: Text(
              challenge.localizedDescription,
            ),
          ),
      ],
      onChanged: (newValue) => controller.matchData.challengeResult.value =
          ClimbingChallengeExtension.fromLocalizedDescription(
              newValue ?? ClimbingChallenge.didntClimb.localizedDescription),
      value: controller.matchData.challengeResult.value.localizedDescription,
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
        Get.to(() => QrCodeScreen(
            matchQrCodes:
                controller.separateEventsToQrCodes(controller.matchData),
            canGoBack: false));
      },
      child: const Text("Show QR Code"),
    );
  }
}
