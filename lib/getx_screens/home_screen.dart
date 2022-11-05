import 'package:flutter/material.dart';
import 'package:frc_scouting/getx_screens/game_screen.dart';
import 'package:frc_scouting/getx_screens/previous_matches_screen.dart';
import 'package:frc_scouting/services/getx_business_logic.dart';
import 'package:get/get.dart';

import '../services/event_key.dart';

class HomeScreen extends StatelessWidget {
  final matchTxtFieldController = TextEditingController();
  final scouterIdTxtFieldController = TextEditingController();
  final teamNumberTxtFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final BusinessLogicController c = Get.put(BusinessLogicController());

    c.resetOrientation();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scouting App 2022'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Choose the FRC Event"),
                DropdownButton(
                  items: [
                    for (EventKey eventKey in eventKeys)
                      DropdownMenuItem(
                        onTap: () => c.selectedEvent = eventKey,
                        value: eventKey,
                        child: Text(eventKey.stringValue),
                      ),
                  ],
                  onChanged: (value) {},
                  value: EventKey.chezyChamps2022,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      TextField(
                        decoration:
                            const InputDecoration(hintText: "Scouter ID"),
                        controller: scouterIdTxtFieldController,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          c.matchData.scouterId.value =
                              int.tryParse(value) ?? 0;
                        },
                      ),
                      TextField(
                        decoration:
                            const InputDecoration(hintText: "Match Number"),
                        controller: matchTxtFieldController,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          c.matchData.matchNumber.value =
                              int.tryParse(value) ?? 0;
                        },
                      ),
                      TextField(
                        decoration:
                            const InputDecoration(hintText: "Team Number"),
                        controller: teamNumberTxtFieldController,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          c.matchData.teamNumber.value =
                              int.tryParse(value) ?? 0;
                        },
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => ElevatedButton(
                    onPressed: !c.isHeaderDataValid()
                        ? null
                        : () {
                            c.matchData.scouterId.value =
                                int.parse(scouterIdTxtFieldController.text);
                            c.matchData.matchNumber.value =
                                int.parse(matchTxtFieldController.text);
                            c.matchData.teamNumber.value =
                                int.parse(teamNumberTxtFieldController.text);
                            Get.to(() => GameScreen());
                          },
                    child: const Text("Start"),
                  ),
                ),
                ElevatedButton(
                  child: const Text("View Previous Matches"),
                  onPressed: () {
                    final matches = c.documentsHelper.getMatches();
                    if (matches.numberOfInvalidFiles > 0) {
                      Get.snackbar(
                        "Invalid Files",
                        "There were ${matches.numberOfInvalidFiles} invalid files found",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                    Get.to(
                      () => PreviousMatchesScreen(
                          matches: c.documentsHelper.getMatches()),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
