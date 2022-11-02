import 'package:flutter/material.dart';
import 'package:frc_scouting/getx_screens/qrcode_screen.dart';
import 'package:get/get.dart';

import '../services/getx_business_logic.dart';

class PostGameScreen extends StatelessWidget {
  List<String> climbingChallenges = [
    "Climbing Challenge",
    "Didn't Climb",
    "Failed Climb",
    "Bottom Bar",
    "Middle Bar",
    "High Bar",
    "Traverse",
  ];

  final notesController = TextEditingController();

  final BusinessLogicController c = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post Game"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Select Climbing Challenge"),
            Obx(
              () => DropdownButton(
                hint: Text(
                  climbingChallenges[0],
                ),
                items: [
                  for (var challenge in climbingChallenges)
                    DropdownMenuItem(
                      value: challenge,
                      child: Text(
                        challenge,
                      ),
                    ),
                ],
                onChanged: (String? newValue) {
                  c.updateClimbingChallenge(newValue!);
                },
                value: c.matchData.value.challengeResult.value,
              ),
            ),
            // Obx(
            //   () => DropdownButton(
            //     items: [
            //       for (String challenge in climbingChallenges)
            //         DropdownMenuItem(
            //           value: challenge,
            //           child: Text(challenge),
            //         ),
            //     ],
            //     onChanged: dropdownButtonValueDidChange,
            //     value: c.matchData.value.challengeResult,
            //   ),
            // ),
            Obx(
              () => ElevatedButton(
                child: const Text("Show QR Code"),
                onPressed: c.matchData.value.challengeResult ==
                        climbingChallenges[0]
                    ? null
                    : () async {
                        await c.saveMatchData(c.matchData.value);

                        Get.to(() => QrCodeScreen(
                              matchQrCodes:
                                  c.separateEventsToQrCodes(c.matchData.value),
                            ));
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
