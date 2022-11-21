import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frc_scouting/getx_screens/game_screen.dart';
import 'package:frc_scouting/services/getx_business_logic.dart';
import 'package:get/get.dart';

import '../services/event_key.dart';
import '../services/scouters_helper.dart';
import 'previous_matches_screen.dart';
import 'scan_qrcode_screen.dart';

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
                                      controller.selectedScouterId.value = -1;
                                      controller.scoutersHelper
                                          .getAllScouters(forceFetch: true);
                                    },
                                    tooltip: "Refresh Scouters",
                                  ),
                                ],
                              ),
                            ),
                            Obx(
                              () => Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Selected Scouter QR ID: ${controller.selectedScouterQrCodeId.value == -1 ? "None" : controller.selectedScouterQrCodeId.value}",
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(CupertinoIcons.qrcode_viewfinder,
                                        color: controller
                                                    .selectedScouterQrCodeId
                                                    .value ==
                                                -1
                                            ? Colors.grey
                                            : Colors.deepPurple),
                                    onPressed: (() async {
                                      final qrCodeResult = await Get.to(
                                          () => ScanQrCodeScreen());
                                      if (qrCodeResult != null &&
                                          int.tryParse(qrCodeResult)
                                              is String) {
                                        controller.selectedScouterQrCodeId
                                            .value = int.parse(qrCodeResult);
                                      } else {
                                        Get.snackbar("Invalid QR Code",
                                            "Please scan a valid QR code",
                                            snackPosition:
                                                SnackPosition.BOTTOM);
                                      }
                                    }),
                                  ),
                                ],
                              ),
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                  hintText: "Match Number"),
                              controller: matchTxtFieldController,
                              keyboardType: TextInputType.number,
                              onChanged: (String value) {
                                controller.matchData.matchNumber.value =
                                    int.tryParse(value) ?? 0;
                                try {
                                  if (controller.matchData.matchNumber.value >
                                          0 &&
                                      controller
                                              .selectedScouterQrCodeId.value !=
                                          -1) {
                                    teamTxtFieldController.text = controller
                                        .eventSchedule[controller
                                                .matchData.matchNumber.value -
                                            1][controller
                                                .selectedScouterQrCodeId.value -
                                            1]
                                        .toString();
                                  }
                                } catch (_) {}
                              },
                            ),
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
                                  controller.selectedScouterId.value)
                              ? null
                              : () async {
                                  controller.matchData.matchNumber.value =
                                      int.parse(matchTxtFieldController.text);
                                  controller.matchData.teamNumber.value =
                                      int.parse(teamTxtFieldController.text);

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
                onPressed: () async {
                  final matches = controller.documentsHelper.getMatches();
                  Get.to(
                    () => PreviousMatchesScreen(
                      matches: matches,
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
            ),
          )
        ],
      ),
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
        for (Scouter scouter in controller.scoutersHelper.scouters)
          DropdownMenuItem(
            onTap: () => controller.selectedScouterId.value = scouter.scouterId,
            value: scouter.scouterId,
            child: Text(scouter.scouterName),
          ),
      ],
      onChanged: (_) {},
      value: controller.selectedScouterId.value,
    );
  }
}
