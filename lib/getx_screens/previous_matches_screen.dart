import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frc_scouting/getx_screens/qrcode_screen.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../services/game_data.dart';
import '../services/getx_business_logic.dart';

class PreviousMatchesScreen extends StatelessWidget {
  final BusinessLogicController c = Get.find();

  late final List<MatchData> matches;

  @override
  Widget build(BuildContext context) {
    matches = c.getMatches();
    print("Files Directory: ${c.directory.path}");
    print("Number of valid matches: ${matches.length}");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Previous Matches"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: matches.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => Get.to(
                () => QrCodeScreen(
                  matchQrCodes: matches[index].separateEventsToQrCodes(),
                ),
              ),
              child: Card(
                child: ListTile(
                  title:
                      Text("Match: ${matches[index].matchNumber.toString()}"),
                  subtitle:
                      Text("Team: ${matches[index].teamNumber.toString()}"),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
