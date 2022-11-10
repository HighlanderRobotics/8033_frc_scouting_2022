import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class ScoutersHelper {
  RxList<Scouter> scouters = <Scouter>[].obs;

  Future getAllScouters() async {
    var response =
        await http.get(Uri.parse('https://v0v0q.mocklab.io/allscouters'));

    if (response.statusCode == 200) {
      scouters.value = (jsonDecode(response.body) as List)
          .map((e) => Scouter.fromJson(e))
          .toList();
    } else {
      throw Exception("Non-200 response code");
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
}
