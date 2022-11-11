import 'package:flutter/material.dart';
import 'package:frc_scouting/getx_screens/game_screen.dart';
import 'package:frc_scouting/getx_screens/previous_matches_screen.dart';
import 'package:frc_scouting/services/getx_business_logic.dart';
import 'package:get/get.dart';

import '../services/event_key.dart';
import '../services/scouters.dart';

class HomeScreen extends StatelessWidget {
  final matchTxtFieldController = TextEditingController();
  final teamNumberTxtFieldController = TextEditingController();

  var selectedEvent = CompetitionKey.chezyChamps2022.obs;
  var selectedScouterId = RxInt(-1);

  @override
  Widget build(BuildContext context) {
    final BusinessLogicController c = Get.put(BusinessLogicController());

    c.resetOrientation();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scouting App 2022'),
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
                      const Text("Choose FRC Event"),
                      DropdownButton(
                        items: [
                          for (CompetitionKey competitionKey
                              in CompetitionKey.values)
                            DropdownMenuItem(
                              onTap: () => c.selectedEvent = competitionKey,
                              value: competitionKey,
                              child: Text(competitionKey.stringValue),
                            ),
                        ],
                        onChanged: (_) {},
                        value: CompetitionKey.chezyChamps2022,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Obx(
                              () => DropdownButton(
                                items: [
                                  const DropdownMenuItem(
                                    value: -1,
                                    child: Text(
                                      "Choose Your Name",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  for (Scouter scouter
                                      in c.scoutersHelper.scouters)
                                    DropdownMenuItem(
                                      onTap: () => selectedScouterId.value =
                                          scouter.scouterId,
                                      value: scouter.scouterId,
                                      child: Text(scouter.scouterName),
                                    ),
                                ],
                                onChanged: (_) {},
                                value: selectedScouterId.value,
                              ),
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                  hintText: "Match Number"),
                              controller: matchTxtFieldController,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                c.matchData.matchNumber.value =
                                    int.tryParse(value) ?? 0;
                              },
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                  hintText: "Team Number"),
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
                              : () async {
                                  c.matchData.matchNumber.value =
                                      int.parse(matchTxtFieldController.text);
                                  c.matchData.teamNumber.value = int.parse(
                                      teamNumberTxtFieldController.text);

                                  if (c.currentOrientation !=
                                      Orientation.landscape) {
                                    c.setLandscapeOrientation();
                                    await Future.delayed(
                                        const Duration(milliseconds: 700));
                                  }

                                  Get.to(() => GameScreen());
                                },
                          child: const Text("Start"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: ElevatedButton(
                child: const Text("View Previous Matches"),
                onPressed: () {
                  final matches = c.documentsHelper.getMatches();
                  if (matches.numberOfInvalidFiles > 0) {
                    Get.snackbar(
                      "Ignored Invalid Files",
                      "There were ${matches.numberOfInvalidFiles} invalid file${matches.numberOfInvalidFiles == 1 ? "s" : ""} found",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                  Get.to(
                    () => PreviousMatchesScreen(
                        matches: c.documentsHelper.getMatches()),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
