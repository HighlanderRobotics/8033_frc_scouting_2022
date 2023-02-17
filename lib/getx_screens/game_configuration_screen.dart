import 'package:flutter/material.dart';
import 'package:frc_scouting/getx_screens/game_screen.dart';
import 'package:frc_scouting/getx_screens/settings_screen.dart';
import 'package:get/get.dart';

import '../services/getx_business_logic.dart';

enum GameConfigurationRotation { left, right }

extension RotationExtension on GameConfigurationRotation {
  String get localizedDescription {
    switch (this) {
      case GameConfigurationRotation.left:
        return "Left";
      case GameConfigurationRotation.right:
        return "Right";
    }
  }

  GameConfigurationRotation getToggledValue() {
    switch (this) {
      case GameConfigurationRotation.left:
        return GameConfigurationRotation.right;
      case GameConfigurationRotation.right:
        return GameConfigurationRotation.left;
    }
  }
}

class GameConfigurationScreen extends StatelessWidget {
  final BusinessLogicController controller = Get.find();
  final SettingsScreenVariables variables = Get.find();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.resetOrientation();
        controller.setPortraitOrientation();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Game Configuration"),
          actions: [
            IconButton(
              icon: const Icon(Icons.rotate_right),
              tooltip: "Rotate Screen",
              onPressed: () => variables.rotation.value =
                  variables.rotation.value.getToggledValue(),
            )
          ],
        ),
        body: Stack(
          children: [
            GameScreen(isInteractive: false),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Obx(
                  () => Text(
                    "Currently Rotated: ${variables.rotation.value.localizedDescription}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
