import 'package:flutter/material.dart';
import 'package:frc_scouting/getx_screens/game_screen.dart';
import 'package:get/get.dart';

import '../services/getx_business_logic.dart';

class GameScreenConfigurationScreen extends StatelessWidget {
  final BusinessLogicController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Screen Congifuration"),
      ),
      body: GameScreen(isInteractive: false),
    );
  }
}
