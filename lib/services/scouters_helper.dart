import 'dart:convert';

import 'package:frc_scouting/services/shared_preferences_helper.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

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
        scouters.value = await _fetchScouters();
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
  Future<List<Scouter>> _getParsedLocalStorageScouters() async {
    final scouterJson = await SharedPreferencesHelper.getString(
        SharedPreferenceKeys.scouters.toShortString());

    if (scouterJson.isNotEmpty) {
      return jsonDecode(scouterJson)
          .map<Scouter>((json) => Scouter.fromJson(json))
          .toList();
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

  // An Internal function to make a network request and decode the json
  // into a List of Scouter objects
  Future<List<Scouter>> _fetchScouters() async {
    try {
      var response =
          await http.get(Uri.parse('https://v0v0q.mocklab.io/allscouters'));

      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((e) => Scouter.fromJson(e))
            .toList();
      } else {
        throw Exception("Non-200 response code");
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}

class Scouter {
  int scouterId;
  String scouterName;

  Scouter({required this.scouterId, required this.scouterName});

  factory Scouter.fromJson(Map<String, dynamic> json) {
    return Scouter(
      scouterId: json["scouterId"],
      scouterName: json["scouterName"],
    );
  }

  Map toJson() => {
        "scouterId": scouterId,
        "scouterName": scouterName,
      };
}
