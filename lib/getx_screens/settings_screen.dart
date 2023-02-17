import 'package:flutter/material.dart';
import 'package:frc_scouting/getx_screens/game_configuration_screen.dart';
import 'package:frc_scouting/getx_screens/scan_qrcode_screen.dart';
import 'package:frc_scouting/helpers/scouters_schedule_helper.dart';
import 'package:frc_scouting/models/scout_schedule.dart';
import 'package:get/get.dart';

import '../helpers/shared_preferences_helper.dart';
import '../services/getx_business_logic.dart';
import 'server_authority_setup_screen.dart';

class SettingsScreenVariables extends GetxController {
  var serverAuthority = "".obs;
  var rotation = GameConfigurationRotation.left.obs;

  @override
  void onInit() async {
    serverAuthority.value =
        await SharedPreferencesHelper.shared.getString("serverAuthority") ?? "";
    rotation.value = GameConfigurationRotation.values[int.tryParse(
          await SharedPreferencesHelper.shared.getString("rotation") ?? "0",
        ) ??
        0];

    if (serverAuthority.value == "localhost:4000" || serverAuthority.isEmpty) {
      Future.delayed(0.seconds, () {
        Get.to(() => SettingsScreen());
      });
    }

    super.onInit();
  }

  Future saveServerAuthority() async {
    await SharedPreferencesHelper.shared.setString(
      "serverAuthority",
      serverAuthority.value,
    );
    await SharedPreferencesHelper.shared.setString(
      "rotation",
      rotation.value.index.toString(),
    );
  }

  Future resetValues() async {
    rotation.value = GameConfigurationRotation.left;
    serverAuthority.value = "localhost:4000";
    saveServerAuthority();
  }
}

class SettingsScreen extends StatelessWidget {
  final BusinessLogicController controller = Get.find();
  final SettingsScreenVariables variables = Get.find();

  bool get isDataValid => hasValidServerAuthority();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
            child: saveConfigurationButton(),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ServerAuthoritySetupScreen(),
                ElevatedButton.icon(
                    icon: const Icon(Icons.qr_code_scanner),
                    onPressed: () async {
                      final qrCodeResult = await Get.to(ScanQrCodeScreen());
                      if (qrCodeResult is String && qrCodeResult.isNotEmpty) {
                        // decode qr code string
                        try {
                          ScoutersScheduleHelper.shared.matchSchedule.value =
                              ScoutersSchedule.fromCompressedJSON(qrCodeResult);

                          ScoutersScheduleHelper.saveParsedLocalStorageSchedule(
                              ScoutersScheduleHelper
                                  .shared.matchSchedule.value);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Successfully updated Scouters Schedule \nVersion ${ScoutersScheduleHelper.shared.matchSchedule.value.version.value}"),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Failed to update Scouters Schedule. \nError: ${e.toString()}"),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      }
                    },
                    label: const Text("Scan Scouter Schedule QR Code")),
                ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    onPressed: () => Get.to(GameConfigurationScreen()),
                    label: const Text("Edit Game Configuration")),
                const SizedBox(height: 10),
                const SizedBox(height: 30),
                deleteConfigurationButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget deleteConfigurationButton() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.delete),
      onPressed: () {
        showDialog(
          context: Get.context!,
          builder: (context) => AlertDialog(
            title: const Text("Delete configuration?"),
            content: const Text(
                "If you continue, you will lose all your settings, and the app will be reset to factory settings."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => Theme.of(context).colorScheme.error),
                    foregroundColor: MaterialStateProperty.resolveWith(
                        (states) => Theme.of(context).colorScheme.onError),
                  ),
                  child: const Text("Delete"),
                  onPressed: () async {
                    final sharedPreferences =
                        await SharedPreferencesHelper.shared.sharedPreferences;
                    await sharedPreferences.clear();
                    await variables.resetValues();
                    controller.reset();
                    
                    Future.delayed(500.milliseconds, () {
                      Get.to(() => SettingsScreen());
                    });
                  })
            ],
          ),
        );
      },
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        backgroundColor: MaterialStateProperty.resolveWith(
            (states) => Theme.of(Get.context!).colorScheme.error),
        foregroundColor: MaterialStateProperty.resolveWith(
            (states) => Theme.of(Get.context!).colorScheme.onError),
      ),
      label: const Text("Delete Configuration"),
    );
  }

  Widget saveConfigurationButton() {
    return Obx(
      () => IconButton(
        icon: Icon(
          Icons.check,
          color: validServerAuthority.hasMatch(variables.serverAuthority.value)
              ? Colors.green
              : Colors.grey,
        ),
        onPressed: () async {
          if (hasValidServerAuthority()) {
            variables.saveServerAuthority();

            await SharedPreferencesHelper.shared
                .setString("serverAuthority", variables.serverAuthority.value);

            await SharedPreferencesHelper.shared.setString(
              "rotation",
              variables.rotation.value.index.toString(),
            );

            controller.serviceHelper.refreshAll(networkRefresh: true);

            ScaffoldMessenger.of(Get.context!).showSnackBar(
              const SnackBar(
                content: Text("Saved Configuration"),
                behavior: SnackBarBehavior.floating,
              ),
            );

            Navigator.of(Get.context!).pop();
          } else {
            ScaffoldMessenger.of(Get.context!).showSnackBar(
              const SnackBar(
                content: Text("Invalid Configuration"),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
      ),
    );
  }

  bool hasValidServerAuthority() =>
      validServerAuthority.hasMatch(variables.serverAuthority.value);
}

RegExp validServerAuthority = RegExp(
    "^((((?!-))(xn--)?[a-zA-Z0-9][a-zA-Z0-9-_]{0,61}[a-zA-Z0-9]{0,1}\\.(xn--)?([a-zA-Z0-9\\-]{1,61}|[a-zA-Z0-9-]{1,30}\\.[a-zA-Z]{2,}))|(localhost))(:\\d+)?\$");
