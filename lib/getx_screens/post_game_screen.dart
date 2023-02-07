import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:frc_scouting/getx_screens/view_qrcode_screen.dart';
import 'package:frc_scouting/models/climbing_challenge.dart';
import 'package:frc_scouting/models/robot_roles.dart';
import 'package:get/get.dart';

import '../services/getx_business_logic.dart';

class PostGameScreen extends StatelessWidget {
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
                  children: [
                    climbingChallengeDropdown(),
                    const SizedBox(height: 20),
                    robotRoleDropdown(),
                    const SizedBox(height: 20),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "Notes",
                        filled: true,
                      ),
                      controller: notesController,
                      onChanged: (text) =>
                          controller.matchData.notes.value = text,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: showQrCodeButton(),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  DropdownSearch<ClimbingChallenge> climbingChallengeDropdown() {
    return DropdownSearch<ClimbingChallenge>(
      items: ClimbingChallenge.values,
      itemAsString: (climbingChallenge) =>
          climbingChallenge.localizedDescription,
      selectedItem: controller.matchData.challengeResult.value,
      onChanged: (climbingChallenge) {
        if (climbingChallenge != null) {
          controller.matchData.challengeResult.value = climbingChallenge;
        }
      },
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Climbing Challenge",
          filled: true,
        ),
      ),
    );
  }

  DropdownSearch<RobotRole> robotRoleDropdown() {
    return DropdownSearch<RobotRole>(
      items: RobotRole.values,
      itemAsString: (robotRole) => robotRole.localizedDescription,
      selectedItem: controller.matchData.robotRole.value,
      onChanged: (robotRole) {
        if (robotRole != null) {
          controller.matchData.robotRole.value = robotRole;
        }
      },
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Robot Role",
          filled: true,
        ),
      ),
    );
  }

  ElevatedButton showQrCodeButton() {
    return ElevatedButton(
      onPressed: () {
        controller.documentsHelper
            .saveAndUploadMatchData(controller.matchData)
            .then((uploadResult) {
          Get.snackbar(
            "Upload ${uploadResult ? "Successful" : "Failed"}",
            uploadResult
                ? "The match has been uploaded to the server"
                : "The match could not be uploaded to the server. Please try again later in the Previous Matches Screen",
            snackPosition: SnackPosition.BOTTOM,
          );
        });

        Get.to(
          () => QrCodeScreen(
              matchQrCodes: controller.separateEventsToQrCodes(
                  matchData: controller.matchData),
              canPopScope: false),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.qr_code),
            SizedBox(width: 10),
            Text("Show QR Code"),
          ],
        ),
      ),
    );
  }
}
