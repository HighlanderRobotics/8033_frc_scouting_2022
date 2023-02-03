import 'package:flutter/material.dart';
import 'package:frc_scouting/getx_screens/game_configuration_screen.dart';
import 'package:frc_scouting/models/service.dart';
import 'package:get/get.dart';

import '../helpers/shared_preferences_helper.dart';
import '../services/getx_business_logic.dart';
import 'server_authority_setup.dart';

class SettingsScreenVariables extends GetxController {
  var serverAuthority = "".obs;
  var rotation = GameConfigurationRotation.left.obs;

  @override
  void onInit() async {
    serverAuthority.value =
        await SharedPreferencesHelper.shared.getString("serverAuthority") ??
            "localhost:4000";
    rotation.value = GameConfigurationRotation.values[int.tryParse(
          await SharedPreferencesHelper.shared.getString("rotation") ?? "0",
        ) ??
        0];

    super.onInit();
  }

  void saveServerAuthority() async {
    await SharedPreferencesHelper.shared.setString(
      "serverAuthority",
      serverAuthority.value,
    );
    await SharedPreferencesHelper.shared.setString(
      "rotation",
      rotation.value.index.toString(),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  final BusinessLogicController controller = Get.find();
  final SettingsScreenVariables variables = Get.find();

  bool get isDataValid => hasValidServerAuthority();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (hasValidServerAuthority()) {
          return true;
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Invalid server authority"),
              content: const Text(
                  "The server authority you entered is invalid. Please enter a valid server authority."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
          );
          return false;
        }
      },
      child: Obx(
        () => Scaffold(
          appBar: AppBar(
            title: const Text("Settings"),
            actions: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
                child: saveConfigurationButton(),
              ),
            ],
            automaticallyImplyLeading:
                validServerAuthority.hasMatch(variables.serverAuthority.value),
          ),
          body: SafeArea(
            child: Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ServerAuthoritySetupScreen(),
                    ElevatedButton(
                        onPressed: () => Get.to(GameConfigurationScreen()),
                        child: const Text("Edit Game Configuration")),
                    const SizedBox(height: 50),
                    deleteConfigurationButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget deleteConfigurationButton() {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: Get.context!,
          builder: (context) => AlertDialog(
            title: const Text("Delete configuration?"),
            content: const Text(
                "If you continue, you will lose all your settings, and the app will be reset to factory settings."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
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
                  onPressed: () {})
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
      child: const Text("Delete Configuration"),
    );
  }

  Widget saveConfigurationButton() {
    return IconButton(
      icon: const Icon(Icons.check, color: Colors.green),
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

          ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(
            content: Text("Saved Configuration"),
            behavior: SnackBarBehavior.floating,
          ));
        } else {
          ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(
            content: Text("Invalid Configuration"),
            behavior: SnackBarBehavior.floating,
          ));
        }
      },
    );
  }

  bool hasValidServerAuthority() =>
      validServerAuthority.hasMatch(variables.serverAuthority.value);
}

RegExp validServerAuthority = RegExp(
    "^((((?!-))(xn--)?[a-zA-Z0-9][a-zA-Z0-9-_]{0,61}[a-zA-Z0-9]{0,1}\\.(xn--)?([a-zA-Z0-9\\-]{1,61}|[a-zA-Z0-9-]{1,30}\\.[a-zA-Z]{2,}))|(localhost))(:\\d+)?\$");
