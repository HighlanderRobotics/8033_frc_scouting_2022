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
import 'game_configuration_screen.dart';
import 'service_status_screen.dart';
import 'previous_matches_screen.dart';

class HomeScreen extends StatelessWidget {
  late BusinessLogicController controller;

  var isCustomMatchSelected = false.obs;

  final matchNumberTxtFieldController = TextEditingController();

  void updateMatchNumberTextField(String newValue, {bool forceUpdate = false}) {
    if (forceUpdate) {
      matchNumberTxtFieldController.text = newValue;
    }

    controller.matchData.matchKey.value.matchNumber =
        int.tryParse(newValue) ?? 0;
    controller.matchData.matchKey.refresh();
    controller.refresh();
  }

  final teamTxtFieldController = TextEditingController();

  void updateTeamTextField(String newValue, {bool forceUpdate = false}) {
    if (forceUpdate) {
      teamTxtFieldController.text = newValue;
    }

    controller.matchData.teamNumber.value = int.tryParse(newValue) ?? 0;
    controller.matchData.teamNumber.refresh();
    controller.refresh();
  }

  @override
  Widget build(BuildContext context) {
    controller = Get.put(BusinessLogicController());
    controller.resetOrientation();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Collection App 2023"),
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
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Obx(() => scouterNameDropdown()),
                              const SizedBox(height: 20),
                              matchBuilderRow(),
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
                  startButton(),
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
    );
  }

  Row matchBuilderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                isCustomMatchSelected.value = switchState;

                if (!switchState) {
                  controller.matchData.matchKey = MatchKey(
                          matchType: MatchType.qualifierMatch, matchNumber: 0)
                      .obs;
                }
              }),
        ),
      ],
    );
  }

  Widget startButton() {
    return ElevatedButton(
      // controller.matchData.matchKey.value.isBlank ||
      //         controller.matchData.scouterName.isEmpty ||
      //         controller.matchData.teamNumber.value == 0
      //     ? null
      //     :
      onPressed: () {
        // if (controller.currentOrientation != Orientation.landscape) {
        //   controller.setLandscapeOrientation();
        //   Future.delayed(
        //     700.milliseconds,
        //     () => Get.to(() => GameScreen()),
        //   );
        // } else {
        //   Get.to(() => GameScreen());
        // }
        Get.to(() => GameConfigurationScreen());
      },
      child: const Text(
        "Start",
        style: TextStyle(fontWeight: FontWeight.bold),
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

            if (matchScheduleAndMatchKey != null) {
              controller.matchData.matchKey.value = matchKey;
              updateMatchNumberTextField("${matchKey.matchNumber}",
                  forceUpdate: true);
              updateTeamTextField("${matchScheduleAndMatchKey.teamNumber}",
                  forceUpdate: true);
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
          controller.matchData.matchKey.value = MatchKey(
              matchNumber:
                  int.tryParse(matchNumberTxtFieldController.text) ?? 0,
              matchType: matchType);
        }
      },
      itemAsString: (item) => item.localizedDescription,
      selectedItem: controller.matchData.matchKey.value.matchType,
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
      onChanged: (String matchNumberString) =>
          updateMatchNumberTextField(matchNumberString),
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
      onChanged: (String teamNumber) => updateTeamTextField(teamNumber),
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
        updateMatchNumberTextField("0", forceUpdate: true);
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
