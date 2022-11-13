import 'package:flutter/material.dart';
import 'package:frc_scouting/custom_widgets/frc_app_bar.dart';
import 'package:frc_scouting/services/match_data.dart';
import 'package:frc_scouting/services/previous_match.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';

import 'qrcode_screen.dart';
import '../services/getx_business_logic.dart';

class PreviousMatchesScreen extends StatelessWidget {
  final BusinessLogicController c = Get.find();
  final txtEditingController = TextEditingController();

  late final MatchInfo matches;
  late final RxList<MatchData> filteredMatches = <MatchData>[].obs;

  PreviousMatchesScreen({required this.matches});

  @override
  Widget build(BuildContext context) {
    print("Files Directory: ${c.documentsHelper.directory.path}");
    print(
        "Number of valid matches: ${matches.validMatches.length} out of ${matches.validMatches.length + matches.numberOfInvalidFiles}");

    filteredMatches.value = matches.validMatches;

    c.resetOrientation();

    filterSearchResultsAndUpdateList("");

    return Scaffold(
      appBar: scoutingAppBar("Previous Matches", actions: [filterDropDown()]),
      body: matches.validMatches.isNotEmpty
          ? previousMatchesListView()
          : noMatchesView(),
    );
  }

  DropdownButtonHideUnderline filterDropDown() {
    return DropdownButtonHideUnderline(
      child: Obx(
        () => Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton(
            items: const [
              DropdownMenuItem(
                value: MatchListFilter.date,
                child: Text("Date"),
              ),
              DropdownMenuItem(
                value: MatchListFilter.hasUploaded,
                child: Text("Uploaded"),
              ),
            ],
            onChanged: (value) {
              if (value is MatchListFilter) {
                c.matchFilterType.value = value;
              }
            },
            value: c.matchFilterType.value,
          ),
        ),
      ),
    );
  }

  Widget previousMatchesListView() {
    return WillPopScope(
      onWillPop: () {
        Get.closeCurrentSnackbar();
        return Future.value(true);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
            child: TextField(
              onChanged: (value) => filterSearchResultsAndUpdateList(value),
              controller: txtEditingController,
              decoration: const InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)))),
            ),
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemBuilder: (context, index) => matchRowView(
                  filteredMatches[index],
                ),
                itemCount: filteredMatches.length,
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget matchRowView(MatchData element) {
    return InkWell(
      onTap: () => Get.to(
        () => QrCodeScreen(
          matchQrCodes: c.separateEventsToQrCodes(element),
          canGoBack: true,
        ),
      ),
      child: Card(
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          leading: const Icon(Icons.qr_code),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Match: ${element.matchNumber.toString()}"),
                  Text(
                    "Team: ${element.teamNumber.toString()}",
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(element.hasSavedToCloud.isTrue
                      ? Icons.cloud_done
                      : Icons.cloud_off),
                ],
              ),
            ],
          ),
          trailing: const Icon(Icons.arrow_forward_ios_rounded),
        ),
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

  void filterSearchResultsAndUpdateList(String query) {
    List<MatchData> searchList = <MatchData>[];

    if (query.isNotEmpty) {
      for (var element in matches.validMatches) {
        if (element.matchNumber.value.toString().contains(query) ||
            element.teamNumber.value.toString().contains(query)) {
          searchList.add(element);
        }
      }
    } else {
      searchList = matches.validMatches;
    }

    if (c.matchFilterType.value == MatchListFilter.date) {
      searchList.sort((a, b) => b.startTime.compareTo(a.startTime));
    } else if (c.matchFilterType.value == MatchListFilter.hasUploaded) {
      for (MatchData matchData in searchList) {
        if (matchData.hasSavedToCloud.value) {
          searchList.remove(matchData);
          searchList.insert(0, matchData);
        }
      }
    }

    filteredMatches.value = searchList;
  }
}
