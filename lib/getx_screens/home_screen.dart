import 'package:flutter/material.dart';
import 'package:frc_scouting/getx_screens/data_entry_screen.dart';
import 'package:frc_scouting/getx_screens/previous_matches_screen.dart';
import 'package:frc_scouting/services/getx_business_logic.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  final matchTxtFieldController = TextEditingController();
  final scouterIdTxtFieldController = TextEditingController();
  final teamNumberTxtFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final BusinessLogicController c = Get.put(BusinessLogicController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Scouting App 2022'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(hintText: "Scouter ID"),
                  controller: scouterIdTxtFieldController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    c.matchData.value.scouterId.value =
                        int.tryParse(value) ?? 0;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(hintText: "Match Number"),
                  controller: matchTxtFieldController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    c.matchData.value.matchNumber.value =
                        int.tryParse(value) ?? 0;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(hintText: "Team Number"),
                  controller: teamNumberTxtFieldController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    c.matchData.value.teamNumber.value =
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
                      c.matchData.value.scouterId.value =
                          int.parse(scouterIdTxtFieldController.text);
                      c.matchData.value.matchNumber.value =
                          int.parse(matchTxtFieldController.text);
                      c.matchData.value.teamNumber.value =
                          int.parse(teamNumberTxtFieldController.text);
                      Get.to(() => DataEntryScreen());
                    },
              child: const Text("Start"),
            ),
          ),
          ElevatedButton(
            child: const Text("View Previous Matches"),
            onPressed: () {
              final matches = c.getMatches();
              if (matches.numberOfInvalidFiles > 0) {
                Get.snackbar(
                  "Invalid Files",
                  "There were ${matches.numberOfInvalidFiles} invalid files found",
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
              Get.to(
                () => PreviousMatchesScreen(matches: c.getMatches()),
              );
            },
          )
        ],
      ),
    );
  }
}
