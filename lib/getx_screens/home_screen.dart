import 'package:flutter/material.dart';
import 'package:frc_scouting/getx_screens/game_screen.dart';
import 'package:frc_scouting/services/getx_business_logic.dart';
import 'package:get/get.dart';

import 'previous_matches_screen.dart';

class HomeScreen extends StatelessWidget {
  final matchTxtFieldController = TextEditingController();
  final teamTxtFieldController = TextEditingController();

  late BusinessLogicController controller;

  @override
  Widget build(BuildContext context) {
    controller = Get.put(BusinessLogicController());
    controller.resetOrientation();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Collection App 2022"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Obx(
                                () => Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    chooseScouterNameDropdownButton(),
                                    IconButton(
                                      icon: const Icon(Icons.refresh,
                                          color: Colors.grey),
                                      onPressed: () {
                                        controller.selectedScouterString.value =
                                            "";
                                        controller.scoutersHelper
                                            .getAllScouters(forceFetch: true);
                                      },
                                      tooltip: "Refresh Scouters",
                                    ),
                                  ],
                                ),
                              ),
                              matchNumberTextField(),
                              TextField(
                                decoration: const InputDecoration(
                                    hintText: "Team Number"),
                                controller: teamTxtFieldController,
                                keyboardType: TextInputType.number,
                                onChanged: (String value) {
                                  controller.matchData.teamNumber.value =
                                      int.tryParse(value) ?? 0;
                                },
                              ),
                            ],
                          ),
                        ),
                        Obx(
                          () => ElevatedButton(
                            onPressed: !controller.isHeaderDataValid(
                                    controller.selectedScouterString.value)
                                ? null
                                : () async {
                                    controller.matchData.matchNumber.value =
                                        int.parse(matchTxtFieldController.text);
                                    controller.matchData.teamNumber.value =
                                        int.parse(teamTxtFieldController.text);

                                    var previousMatches = controller
                                        .documentsHelper
                                        .getPreviousMatches();

                                    for (var match in previousMatches
                                        .validMatches
                                        .where((element) =>
                                            element.matchNumber.value ==
                                            controller
                                                .matchData.matchNumber.value)) {
                                      if (match.teamNumber.value ==
                                          controller
                                              .matchData.teamNumber.value) {
                                        Get.snackbar("Match Already Exists",
                                            "This match already exists in the database. Please delete it first.",
                                            snackPosition:
                                                SnackPosition.BOTTOM);
                                        return;
                                      }
                                    }

                                    if (controller.currentOrientation !=
                                        Orientation.landscape) {
                                      controller.setLandscapeOrientation();
                                      await Future.delayed(
                                          const Duration(milliseconds: 700));
                                    }

                                    Get.to(() => GameScreen());
                                  },
                            child: const Text("Start"),
                          ),
                        ),
                      ]),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: const Text("Previous Matches"),
                    onPressed: () async {
                      final matches =
                          controller.documentsHelper.getPreviousMatches();
                      Get.to(
                        () => PreviousMatchesScreen(
                          previousMatches: matches,
                        ),
                      );
                      if (matches.numberOfInvalidFiles > 0) {
                        Get.snackbar(
                          "Ignored Invalid Files",
                          "There were ${matches.numberOfInvalidFiles} invalid file${matches.numberOfInvalidFiles == 1 ? "s" : ""} found",
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    child: const Text("Match Schedule"),
                    onPressed: () async {},
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  TextField matchNumberTextField() {
    return TextField(
      decoration: const InputDecoration(hintText: "Match Number"),
      controller: matchTxtFieldController,
      keyboardType: TextInputType.number,
      onChanged: (String value) {
        controller.matchData.matchNumber.value = int.tryParse(value) ?? 0;

        controller.scoutersScheduleHelper.matchSchedule.value.matches
            .firstWhereOrNull((element) => element.scouters
                .contains(controller.selectedScouterString.value));

        try {
          if (controller.matchData.matchNumber.value > 0 &&
              controller.scoutersScheduleHelper.matchSchedule.value
                  .containsScouter(controller.selectedScouterString.value)) {
            teamTxtFieldController.text = controller
                .eventSchedule[controller.matchData.matchNumber.value - 1][
                    controller.scoutersHelper.scouters
                        .indexOf(controller.selectedScouterString.value)]
                .toString();
          } else {
            teamTxtFieldController.text = "";
          }
        } catch (_) {
          teamTxtFieldController.text = "";
        }
      },
    );
  }

  DropdownButton<int> chooseScouterNameDropdownButton() {
    return DropdownButton(
      items: [
        const DropdownMenuItem(
          value: -1,
          child: Text(
            "Choose Your Name",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        for (String scouterName in controller.scoutersHelper.scouters)
          DropdownMenuItem(
            onTap: () => controller.selectedScouterString.value = scouterName,
            value: controller.scoutersHelper.scouters.indexOf(scouterName),
            child: Text(scouterName),
          ),
      ],
      onChanged: (_) {},
      value: controller.scoutersHelper.scouters
          .indexOf(controller.selectedScouterString.value),
    );
  }
}
