import 'dart:convert';

import 'package:frc_scouting/models/tournament.dart';
import 'package:get/get.dart';

import 'game_configuration_rotation.dart';
import '../getx_screens/settings_screen.dart';
import '../helpers/shared_preferences_helper.dart';
import 'constants.dart';

class SettingsScreenVariables extends GetxController {
  var serverAuthority = "".obs;
  var rotation = GameConfigurationRotation.standard.obs;
  var selectedTournamentKey = Tournament(name: "name", key: "key").obs;

  @override
  void onInit() async {
    serverAuthority = (await SharedPreferencesHelper.shared.getString(
                SharedPreferenceKeys.serverAuthority.toShortString()) ??
            "")
        .obs;

    rotation = GameConfigurationRotation
        .values[int.tryParse(
              await SharedPreferencesHelper.shared.getString(
                      SharedPreferenceKeys.rotation.toShortString()) ??
                  "0",
            ) ??
            0]
        .obs;

    selectedTournamentKey = Tournament.fromJson(
      jsonDecode(await SharedPreferencesHelper.shared.getString(
              SharedPreferenceKeys.selectedTournamentKey.toShortString()) ??
          ""),
    ).obs;

    if (serverAuthority.isEmpty) {
      Get.to(() => SettingsScreen());
    }

    super.onInit();
  }

  Future saveValues() async {
    await SharedPreferencesHelper.shared.setString(
      "serverAuthority",
      serverAuthority.value,
    );
    await SharedPreferencesHelper.shared.setString(
      "rotation",
      rotation.value.index.toString(),
    );
    await SharedPreferencesHelper.shared.setString(
      "selectedTournamentKey",
      jsonEncode(selectedTournamentKey.value.toJson()),
    );
  }

  Future resetValues() async {
    rotation.value = GameConfigurationRotation.standard;
    serverAuthority.value = "";
    selectedTournamentKey.value = Constants.shared.tournamentKeys.first;
    await saveValues();
  }
}
