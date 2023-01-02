import 'dart:convert';

import 'package:frc_scouting/helpers/shared_preferences_helper.dart';
import 'package:frc_scouting/models/service.dart';
import 'package:get/get.dart';

import '../networking/scouting_server_api.dart';

class ScoutersHelper extends ServiceClass {
  static ScoutersHelper shared = ScoutersHelper();

  // A reactive list to hold all the Scouter Objects
  RxList<String> scouters = <String>[].obs;

  @override
  void refresh({bool networkRefresh = false}) {
    try {
      getAllScouters(networkRefresh: networkRefresh);
    } catch (_) {}
  }

  ScoutersHelper() {
    service = Service(name: "Scouters").obs;
  }

  // fetch scouters from storage
  // if invalid or is asked to forceFetch, it fetches the new values to the server
  // Additionally, it saves the new fetch to localStorage
  Future getAllScouters({bool networkRefresh = false}) async {
    try {
      service.value
          .updateStatus(ServiceStatus.inProgress, "Fetching from localStorage");
      final localStorageScouters = await _getParsedLocalStorageScouters();

      if (networkRefresh || localStorageScouters.isEmpty) {
        scouters.value = await ScoutingServerAPI.getScouters();
        _saveParsedLocalStorageScouters(scouters.toList());
        service.value.updateStatus(ServiceStatus.up, "Retrieved from network");
      } else {
        scouters.value = localStorageScouters;
        service.value
            .updateStatus(ServiceStatus.up, "Retrieved from localStorage");
      }
    } catch (e) {
      print("Error Occured: $e");
      service.value.updateStatus(
          ServiceStatus.error, "Network or parsing error: ${e.toString()}");
    }
  }

  // Abstracted function to get the scouters from localStorage
  // Then it parses the JSON and returns a list of Scouter objects
  Future<List<String>> _getParsedLocalStorageScouters() async {
    final scouterJson = await SharedPreferencesHelper.shared
        .getString(SharedPreferenceKeys.scouters.toShortString());

    if (scouterJson.isNotEmpty) {
      try {
        return List<String>.from(jsonDecode(scouterJson));
      } catch (e) {
        print("Failed to parse localStorage scouters: $e");
        return [];
      }
    } else {
      return [];
    }
  }

  // Internal function that saves a given list of Scouters to localStorage
  Future _saveParsedLocalStorageScouters(List<String> scouters) async {
    final prefs = await SharedPreferencesHelper.shared.sharedPreferences;
    final scouterJson = jsonEncode(scouters);
    prefs.setString('scouters', scouterJson);
  }
}
