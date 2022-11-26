import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frc_scouting/services/match_data/match_data.dart';
import 'package:frc_scouting/services/previous_match.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';

import 'view_qrcode_screen.dart';
import '../services/getx_business_logic.dart';

class PreviousMatchesScreen extends StatelessWidget {
  final BusinessLogicController controller = Get.find();
  final txtEditingController = TextEditingController();

  MatchInfo matches;
  late final RxList<MatchData> filteredMatches = <MatchData>[].obs;

  PreviousMatchesScreen({required this.matches});

  @override
  Widget build(BuildContext context) {
    print("Files Directory: ${controller.documentsHelper.directory.path}");
    print(
        "Number of valid matches: ${matches.validMatches.length} out of ${matches.validMatches.length + matches.numberOfInvalidFiles}");

    filteredMatches.value = matches.validMatches;

    controller.resetOrientation();

    filterSearchResultsAndUpdateList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Previous Matches"),
      ),
      body: matches.validMatches.isNotEmpty || filteredMatches.isNotEmpty
          ? previousMatchesListView()
          : noMatchesView(),
    );
  }

  Widget filterPopupMenu() {
    return Obx(
      () => PopupMenuButton(
        onSelected: (value) {
          controller.matchFilterType.value = value;
          filterSearchResultsAndUpdateList();
        },
        initialValue: controller.matchFilterType.value,
        icon: const Icon(Icons.filter_list),
        itemBuilder: (context) => [
          filterPopupMenuItem(MatchFilterType.date),
          filterPopupMenuItem(MatchFilterType.hasNotUploaded),
        ],
      ),
    );
  }

  PopupMenuItem filterPopupMenuItem(MatchFilterType filter) {
    return PopupMenuItem(
      onTap: () {},
      value: filter,
      child: ListTile(
        leading: Icon(
            filter == MatchFilterType.date ? Icons.today : Icons.cloud_off),
        title: Text(filter.name),
        trailing: controller.matchFilterType.value == filter
            ? const Icon(Icons.check)
            : null,
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
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10),
            child: TextField(
              onChanged: (_) => filterSearchResultsAndUpdateList(),
              controller: txtEditingController,
              decoration: InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  suffixIcon: filterPopupMenu(),
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
            ),
          ),
          Expanded(
            child: Obx(
              () => ImplicitlyAnimatedReorderableList<MatchData>(
                items: filteredMatches.toList(),
                itemBuilder: (context, animation, item, index) {
                  return Reorderable(
                    key: GlobalKey(),
                    child: SizeFadeTransition(
                      sizeFraction: 0.7,
                      curve: Curves.easeInOut,
                      animation: animation,
                      child: Dismissible(
                        key: GlobalKey(),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) async {
                          Get.closeAllSnackbars();

                          HapticFeedback.lightImpact();

                          await controller.documentsHelper
                              .deleteFile(item.uuid);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text("Deleted ${item.matchNumber.value}"),
                              action: SnackBarAction(
                                label: "Undo",
                                onPressed: () {
                                  controller.documentsHelper
                                      .saveMatchData(item);
                                  controller.documentsHelper.getMatches();
                                  filterSearchResultsAndUpdateList();
                                },
                              ),
                              duration: const Duration(seconds: 3),
                            ),
                          );

                          // Get.snackbar(
                          //   "Match Deleted",
                          //   "Match ${item.matchNumber} has been deleted",
                          //   duration: const Duration(seconds: 2),
                          //   snackPosition: SnackPosition.BOTTOM,
                          //   backgroundColor: Colors.deepPurple,
                          //   colorText: Colors.white,
                          // );
                        },
                        background: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.red,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 5,
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 20),
                                Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        child: matchRowView(
                          filteredMatches[index],
                        ),
                      ),
                    ),
                  );
                },
                areItemsTheSame: (oldItem, newItem) => oldItem == newItem,
                onReorderFinished: (item, from, to, newItems) => {},
              ),
              // () => ListView.builder(
              // itemBuilder: (context, index) => matchRowView(
              //   filteredMatches[index],
              // ),
              //   itemCount: filteredMatches.length,
            ),
          ),
        ]),
      ),
    );
  }

  Widget matchRowView(MatchData element) {
    return Card(
      child: InkWell(
        onTap: () => Get.to(
          () => QrCodeScreen(
            matchQrCodes: controller.separateEventsToQrCodes(element),
            canGoBack: true,
          ),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Match: ${element.matchNumber.toString()}"),
                    Text(
                      "Team: ${element.teamNumber.toString()}",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      element.startTime.format(),
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(element.hasNotSavedToCloud.isTrue
                  ? Icons.cloud_done
                  : Icons.cloud_off),
              const SizedBox(width: 10),
              const Icon(Icons.arrow_forward_ios_rounded),
            ],
          ),
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

  void filterSearchResultsAndUpdateList() {
    List<MatchData> searchList = <MatchData>[];

    if (txtEditingController.text.isNotEmpty) {
      searchList = matches.validMatches
          .where((element) => element.matchNumber
              .toString()
              .contains(txtEditingController.text))
          .toList();
    } else {
      searchList = matches.validMatches;
    }

    switch (controller.matchFilterType.value) {
      case MatchFilterType.date:
        searchList.sort((a, b) => b.startTime.compareTo(a.startTime));
        break;
      case MatchFilterType.hasNotUploaded:
        for (MatchData matchData in searchList) {
          if (matchData.hasNotSavedToCloud.isFalse) {
            searchList.remove(matchData);
            searchList.insert(0, matchData);
          }
        }
        break;
    }

    filteredMatches.value = searchList;
    filteredMatches.refresh();
  }
}

extension DateTimeExtension on DateTime {
  String format() {
    if (DateTime.now().difference(this).inDays < 1) {
      return "Today at ${DateFormat('h:mm a').format(this)}";
    } else if (DateTime.now().difference(this).inDays < 2) {
      return "Yesterday at ${DateFormat('h:mm a').format(this)}";
    } else {
      return DateFormat('M/d/y').format(this);
    }
  }
}
