import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:frc_scouting/getx_screens/game_screen.dart';
import 'package:frc_scouting/helpers/match_schedule_helper.dart';
import 'package:frc_scouting/helpers/scouters_helper.dart';
import 'package:frc_scouting/helpers/scouters_schedule_helper.dart';
import 'package:frc_scouting/services/getx_business_logic.dart';
import 'package:get/get.dart';

import 'service_status_screen.dart';
import 'previous_matches_screen.dart';

class HomeScreen extends StatelessWidget {
  final teamTxtFieldController = TextEditingController();

  late BusinessLogicController controller;

  @override
  Widget build(BuildContext context) {
    controller = Get.put(BusinessLogicController());
    controller.resetOrientation();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Collection App 2022"),
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                Icons.bolt,
                color: controller.serviceHelper.isAllUp
                    ? Colors.green
                    : Colors.red,
              ),
              onPressed: () {
                Get.to(() => ServiceStatusScreen());
              },
            ),
          ),
        ],
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
                                    Expanded(child: scouterNameDropdown()),
                                    IconButton(
                                      icon: const Icon(Icons.refresh,
                                          color: Colors.grey),
                                      onPressed: () {
                                        controller.matchData.scouterName.value =
                                            "";
                                        ScoutersHelper.shared.getAllScouters(
                                            networkRefresh: true);
                                      },
                                      tooltip: "Refresh Scouters",
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(child: matchKeyDropdown()),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.plus_one))
                                ],
                              ),
                              const SizedBox(height: 10),
                              teamNumberTextField(),
                            ],
                          ),
                        ),
                        Obx(
                          () => ElevatedButton(
                            onPressed: !controller.isHeaderDataValid()
                                ? null
                                : () async {
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
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          ),
        ],
      ),
    );
  }

  Widget matchKeyDropdown() {
    return Obx(
      () => DropdownSearch<String>(
        dropdownDecoratorProps: const DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            labelText: "Match",
            border: OutlineInputBorder(),
          ),
        ),
        popupProps: const PopupProps.menu(showSelectedItems: true),
        items: [
          for (var scoutShift in MatchScheduleHelper.shared
              .getMatchesFromShifts(
                  shifts: ScoutersScheduleHelper.shared.matchSchedule.value
                      .filterShiftsWithScouter(
                          controller.matchData.scouterName.value),
                  scouterName: controller.matchData.scouterName.value))
            scoutShift.localizedDescription
        ],
        onChanged: (matchLocalizedDescription) {
          if (matchLocalizedDescription is String) {
            controller.matchData.matchKey.value = matchLocalizedDescription;
            final a = MatchScheduleHelper.shared.matchSchedule.firstWhereOrNull(
                (match) =>
                    match.localizedDescription == matchLocalizedDescription);

            final b = a?.teamKey.substring(3) ?? "";

            if (int.tryParse(b) != null) {
              teamTxtFieldController.text = b;
              controller.matchData.teamNumber.value = int.parse(b);
            }
          }
        },
        selectedItem: controller.matchData.matchKey.value,
      ),
    );
  }

  TextField teamNumberTextField() {
    return TextField(
      decoration: const InputDecoration(hintText: "Team Number"),
      controller: teamTxtFieldController,
      keyboardType: TextInputType.number,
      onChanged: (String teamNumber) {
        controller.matchData.teamNumber.value = int.tryParse(teamNumber) ?? 0;
      },
    );
  }

  DropdownSearch<String> scouterNameDropdown() {
    return DropdownSearch<String>(
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
            labelText: "Scouter Name", border: OutlineInputBorder()),
      ),
      popupProps: const PopupProps.menu(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            label: Text("Search"),
            border: OutlineInputBorder(),
          ),
        ),
      ),
      items: ScoutersHelper.shared.scouters,
      // items: [
      //   for (String scouterName in ScoutersHelper.shared.scouters) scouterName
      // ],
      selectedItem: controller.matchData.scouterName.value,
      onChanged: (value) {
        controller.matchData.scouterName.value = value ?? "";
        controller.matchData.teamNumber = 0.obs;
        controller.matchData.matchKey.value = "";

        teamTxtFieldController.text = "";
      },
    );
    // return DropdownButton(
    //   items: [
    //     const DropdownMenuItem(
    //       value: -1,
    //       child: Text(
    //         "Choose Your Name",
    //         style: TextStyle(color: Colors.grey),
    //       ),
    //     ),
    //     for (String scouterName in ScoutersHelper.shared.scouters)
    //       DropdownMenuItem(
    //         onTap: () => controller.selectedScouterString.value = scouterName,
    //         value: ScoutersHelper.shared.scouters.indexOf(scouterName),
    //         child: Text(scouterName),
    //       ),
    //   ],
    //   onChanged: (_) {},
    //   value: ScoutersHelper.shared.scouters
    //       .indexOf(controller.selectedScouterString.value),
    // );
  }
}
