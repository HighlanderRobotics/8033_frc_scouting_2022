import 'package:flutter/material.dart';
import 'package:frc_scouting/services/previous_match.dart';
import 'package:get/get.dart';

import 'qrcode_screen.dart';
import '../services/getx_business_logic.dart';

class PreviousMatchesScreen extends StatelessWidget {
  final BusinessLogicController c = Get.find();

  late final MatchInfo matches;

  PreviousMatchesScreen({required this.matches});

  @override
  Widget build(BuildContext context) {
    print("Files Directory: ${c.directory.path}");
    print(
        "Number of valid matches: ${matches.validMatches.length} out of ${matches.validMatches.length + matches.numberOfInvalidFiles}");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Previous Matches"),
      ),
      body: matches.validMatches.isNotEmpty
          ? previousMatchesListView()
          : noMatchesView(),
    );
  }

  Widget previousMatchesListView() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView.builder(
        itemCount: matches.validMatches.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => Get.to(
              () => QrCodeScreen(
                matchQrCodes:
                    c.separateEventsToQrCodes(matches.validMatches[index]),
              ),
            ),
            child: Card(
              child: ListTile(
                title: Text(
                    "Match: ${matches.validMatches[index].matchNumber.toString()}"),
                subtitle: Text(
                    "Team: ${matches.validMatches[index].teamNumber.toString()}"),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget noMatchesView() {
    return const Center(
      child: Text(
        "No matches found",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
