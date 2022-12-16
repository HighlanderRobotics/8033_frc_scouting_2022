import 'dart:convert';

import 'package:frc_scouting/helpers/shared_preferences_helper.dart';
import 'package:get/get.dart';

import '../models/scouter.dart';
import '../networking/scouting_server_api.dart';

class ScoutersHelper {
  // A reactive list to hold all the Scouter Objects
  RxList<Scouter> scouters = <Scouter>[].obs;

  // fetch scouters from storage
  // if invalid or is asked to forceFetch, it fetches the new values to the server
  // Additionally, it saves the new fetch to localStorage
  Future getAllScouters({bool forceFetch = false}) async {
    try {
      final localStorageScouters = await _getParsedLocalStorageScouters();

      if (forceFetch || localStorageScouters.isEmpty) {
        scouters.value = await ScoutingServerAPI.fetchScouters();
        _saveParsedLocalStorageScouters(scouters.toList());
      } else {
        scouters.value = localStorageScouters;
      }
    } catch (e) {
      print("Error Occured: $e");
    }
  }

  // Abstracted function to get the scouters from localStorage
  // Then it parses the JSON and returns a list of Scouter objects
  static Future<List<Scouter>> _getParsedLocalStorageScouters() async {
    final scouterJson = await SharedPreferencesHelper.getString(
        SharedPreferenceKeys.scouters.toShortString());

    if (scouterJson.isNotEmpty) {
      try {
        return jsonDecode(scouterJson)
            .map<Scouter>((json) => Scouter.fromJson(json))
            .toList();
      } catch (e) {
        print("Failed to parse localStorage scouters: $e");
        return [];
      }
    } else {
      return [];
    }
  }

  // Internal function that saves a given list of Scouters to localStorage
  Future _saveParsedLocalStorageScouters(List<Scouter> scouters) async {
    final prefs = await SharedPreferencesHelper.sharedPreferences;
    final scouterJson = jsonEncode(scouters);
    prefs.setString('scouters', scouterJson);
  }
}
