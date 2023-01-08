import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frc_scouting/getx_screens/game_screen.dart';
import 'package:frc_scouting/helpers/match_schedule_helper.dart';
import 'package:frc_scouting/helpers/scouters_helper.dart';
import 'package:frc_scouting/helpers/scouters_schedule_helper.dart';
import 'package:frc_scouting/models/match_event.dart';
import 'package:frc_scouting/models/match_key.dart';
import 'package:frc_scouting/services/getx_business_logic.dart';
import 'package:get/get.dart';

import '../models/match_type.dart';
import 'service_status_screen.dart';
import 'previous_matches_screen.dart';

class HomeScreen extends StatelessWidget {
  final teamTxtFieldController = TextEditingController();

  late BusinessLogicController controller;

  var isCustomMatchSelected = false.obs;

  final matchNumberTxtFieldController = TextEditingController();

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
      body: Obx(
        () => Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Obx(
                                  () => scouterNameDropdown(),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          Text("Match Builder"),
                                          Text(
                                            "Use only when there is no upcoming matches available to choose from.",
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Obx(
                                      () => Switch(
                                          value: isCustomMatchSelected.value,
                                          onChanged: (bool switchState) {
                                            HapticFeedback.lightImpact();
                                            isCustomMatchSelected.value =
                                                switchState;

                                            if (!switchState) {
                                              controller.matchData.matchKey =
                                                  null.obs;
                                            }
                                          }),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Obx(
                                  () => isCustomMatchSelected.isFalse
                                      ? matchKeyDropdown()
                                      : Column(
                                          children: [
                                            matchTypeDropdown(),
                                            const SizedBox(height: 20),
                                            matchNumberTextField(),
                                          ],
                                        ),
                                ),
                                const SizedBox(height: 20),
                                teamNumberTextField(),
                              ],
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: !(controller.matchData.matchKey != null.obs &&
                              controller.matchData.scouterName.isNotEmpty &&
                              controller.matchData.teamNumber.value != 0)
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
                      child: const Text(
                        "Start",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget matchKeyDropdown() {
    return Obx(
      () => DropdownSearch<MatchKey>(
        dropdownDecoratorProps: const DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            labelText: "Match",
            border: OutlineInputBorder(),
            filled: true,
          ),
        ),
        items:
            matchesFromShifts.map((matchEvent) => matchEvent.matchKey).toList(),
        onChanged: (matchKey) {
          if (matchKey != null) {
            controller.matchData.matchKey = matchKey.obs;
            final matchScheduleAndMatchKey = MatchScheduleHelper
                .shared.matchSchedule
                .firstWhereOrNull((match) => match.matchKey == matchKey);

            if (controller.matchData.matchKey.value == null) {
              controller.matchData.matchKey = matchKey.obs;
            }

            if (matchScheduleAndMatchKey != null) {
              teamTxtFieldController.text =
                  "${matchScheduleAndMatchKey.teamNumber}";
              matchNumberTxtFieldController.text = "${matchKey.matchNumber}";
              controller.matchData.teamNumber.value =
                  matchScheduleAndMatchKey.teamNumber;
            }
          }
        },
        selectedItem: matchesFromShifts
                .map((matchEvent) => matchEvent.matchKey)
                .toList()
                .contains(controller.matchData.matchKey.value)
            ? controller.matchData.matchKey.value
            : null,
        itemAsString: (item) => item.localizedDescription,
      ),
    );
  }

  Widget matchTypeDropdown() {
    return DropdownSearch<MatchType>(
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Match Type",
          border: OutlineInputBorder(),
          filled: true,
        ),
      ),
      // popupProps: const PopupProps.menu(
      //   showSelectedItems: true,
      // ),
      items: MatchType.values,
      onChanged: (matchType) {
        if (matchType != null) {
          // ignore: prefer_conditional_assignment
          if (controller.matchData.matchKey.value == null) {
            controller.matchData.matchKey = MatchKey(
                    matchNumber:
                        int.tryParse(matchNumberTxtFieldController.text) ?? 0,
                    matchType: matchType)
                .obs;
          } else {
            controller.matchData.matchKey.value!.matchType = matchType;
          }
          controller.update();
        }
      },
      itemAsString: (item) => item.localizedDescription,
      selectedItem: controller.matchData.matchKey.value?.matchType,
    );

    // return DropdownButton<MatchType>(
    //   hint: const Text("Match Type"),
    //   items: [
    //     for (final matchType in MatchType.values)
    //       DropdownMenuItem(
    //           value: matchType, child: Text(matchType.localizedDescription))
    //   ],
    //   onChanged: (value) {
    //     if (value != null) {}
    //   },
    //   value: null,
    // );
  }

  Widget matchNumberTextField() {
    return TextField(
      decoration: const InputDecoration(
        hintText: "Match Number",
        filled: true,
      ),
      controller: matchNumberTxtFieldController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (String matchNumberString) {
        final matchNumber = int.parse(matchNumberString);

        if (matchNumber > 65) {
          return;
        }

        controller.matchData.matchKey.value ??= MatchKey(
            matchNumber: matchNumber,
            matchType: controller.matchData.matchKey.value?.matchType ??
                MatchType.quarterFinals);
      },
    );
  }

  TextField teamNumberTextField() {
    return TextField(
      decoration: const InputDecoration(
        hintText: "Team Number",
        filled: true,
      ),
      controller: teamTxtFieldController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (String teamNumber) {
        controller.matchData.teamNumber.value = int.tryParse(teamNumber) ?? 0;
      },
    );
  }

  DropdownSearch<String> scouterNameDropdown() {
    return DropdownSearch<String>(
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Scouter Name",
          border: OutlineInputBorder(),
          filled: true,
        ),
      ),
      popupProps: PopupProps.dialog(
        emptyBuilder: (context, searchEntry) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Text("No Scouter Found"),
          );
        },
        fit: FlexFit.loose,
        showSearchBox: true,
        searchFieldProps: const TextFieldProps(
          padding: EdgeInsets.all(20),
          decoration: InputDecoration(
            label: Text("Search"),
            border: OutlineInputBorder(),
            filled: true,
          ),
        ),
      ),
      items: ScoutersHelper.shared.scouters,
      selectedItem: controller.matchData.scouterName.value,
      onChanged: (value) {
        controller.matchData.scouterName.value = value ?? "";
        controller.matchData.teamNumber = 0.obs;

        teamTxtFieldController.text = "";
      },
    );
  }

  List<MatchEvent> get matchesFromShifts {
    return MatchScheduleHelper.shared.getMatchesFromShifts(
      shifts: ScoutersScheduleHelper.shared.matchSchedule.value
          .filterShiftsWithScouter(
        controller.matchData.scouterName.value,
      ),
      scouterName: controller.matchData.scouterName.value,
    );
  }
}

extension ListGetExtension<T> on List<T> {
  T? tryGet(int index) => index < 0 || index >= length ? null : this[index];
}
