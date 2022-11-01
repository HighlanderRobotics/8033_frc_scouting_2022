import 'package:flutter/material.dart';
import 'package:frc_scouting/getx_screens/qrcode_screen.dart';
import 'package:get/get.dart';

import '../services/getx_business_logic.dart';

class PostGameScreen extends StatelessWidget {
  List<String> climbingChallenges = [
    'Climbing Challenge',
    'Didn\'t Climb',
    'Failed Climb',
    'Bottom Bar',
    'Middle Bar',
    'High Bar',
    'Traverse',
  ];
  bool didDefense = false;
  final notesController = TextEditingController();

  final BusinessLogicController c = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Game"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(
            () => Text(
                "Selected Challenge: ${c.matchData.value.challengeResult}"),
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (String climbingChallenge in climbingChallenges)
                  ElevatedButton(
                      child: Text(climbingChallenge),
                      onPressed: () => c.matchData.value.challengeResult.value =
                          climbingChallenge),
              ]),
          ElevatedButton(
            child: const Text("Go to QR Code"),
            onPressed: () => Get.to(
              () => QrCodeScreen(),
            ),
          )
        ],
      ),
    );
  }
}
