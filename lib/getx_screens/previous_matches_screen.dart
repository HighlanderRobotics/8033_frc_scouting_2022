import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frc_scouting/services/match_data/match_data.dart';
import 'package:frc_scouting/services/previous_matches_info.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';

import 'view_qrcode_screen.dart';
import '../services/getx_business_logic.dart';

class PreviousMatchesScreen extends StatelessWidget {
  final BusinessLogicController controller = Get.find();
  final txtEditingController = TextEditingController();

  PreviousMatchesInfo previousMatches;
  late final RxList<MatchData> filteredMatches = <MatchData>[].obs;

  var isDismissThresholdReached = false.obs;

  PreviousMatchesScreen({required this.previousMatches});

  @override
  Widget build(BuildContext context) {
    print("Files Directory: ${controller.documentsHelper.directory.path}");
    print(
        "Number of valid matches: ${previousMatches.validMatches.length} out of ${previousMatches.validMatches.length + previousMatches.numberOfInvalidFiles}");

    filteredMatches.value = previousMatches.validMatches;

    controller.resetOrientation();

    filterSearchResultsAndUpdateList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Previous Matches"),
      ),
      body:
          previousMatches.validMatches.isNotEmpty || filteredMatches.isNotEmpty
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
        Obx(
          () => Expanded(
            child: ImplicitlyAnimatedReorderableList<MatchData>(
              items: filteredMatches.toList(),
              itemBuilder: (context, animation, matchData, _) {
                return Reorderable(
                  key: GlobalKey(),
                  child: SizeFadeTransition(
                      sizeFraction: 0.7,
                      curve: Curves.easeOut,
                      animation: animation,
                      child: Dismissible(
                        onUpdate: (details) {
                          isDismissThresholdReached.value = details.reached;

                          if ((details.reached && !details.previousReached) || (!details.reached && details.previousReached)) {
                            HapticFeedback.lightImpact();
                          }
                        },
                        key: GlobalKey(),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) {
                          Get.closeAllSnackbars();

                          isDismissThresholdReached.value = false;

                          Future.sync(() => controller.documentsHelper
                              .deleteFile(matchData.uuid));

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Deleted ${matchData.matchNumber.value}"),
                              action: SnackBarAction(
                                label: "Undo",
                                onPressed: () {
                                  controller.documentsHelper
                                      .saveMatchData(matchData);
                                  controller.documentsHelper
                                      .getPreviousMatches();
                                  filterSearchResultsAndUpdateList();
                                },
                              ),
                              duration: 3.seconds,
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
                          color: Colors.red[900],
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Obx(
                                  () => AnimatedScale(
                                    duration: 0.5.seconds,
                                    curve: Curves.bounceOut,
                                    scale: isDismissThresholdReached.isTrue
                                        ? 1.4
                                        : 0.7,
                                    child: const Icon(Icons.delete),
                                  ),
                                ),
                                const SizedBox(width: 30),
                              ],
                            ),
                          ),
                        ),
                        child: matchRowView(matchData, context),
                      )),
                );
              },
              areItemsTheSame: (oldItem, newItem) => oldItem == newItem,
              onReorderFinished: (item, from, to, newItems) => {},
            ),
          ),
        ),
      ]),
    );
  }

  Widget matchRowView(MatchData matchData, BuildContext context) {
    return InkWell(
      child: ListTile(
        onTap: () => Get.to(
          () => QrCodeScreen(
            matchQrCodes: controller.separateEventsToQrCodes(matchData),
            canGoBack: true,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Match: ${matchData.matchNumber.toString()}"),
                  Text(
                    "Team: ${matchData.teamNumber.toString()}",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    matchData.startTime.format(),
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
            Icon(matchData.hasNotSavedToCloud.isTrue
                ? Icons.cloud_done
                : Icons.cloud_off),
            const SizedBox(width: 10),
            const Icon(Icons.arrow_forward_ios_rounded),
          ],
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
    // List<MatchData> searchList = <MatchData>[];

    if (txtEditingController.text.isNotEmpty) {
      filteredMatches.value = previousMatches.validMatches
          .where((element) => element.matchNumber
              .toString()
              .contains(txtEditingController.text))
          .toList();
    } else {
      filteredMatches.value = previousMatches.validMatches;
    }

    switch (controller.matchFilterType.value) {
      case MatchFilterType.date:
        filteredMatches.sort((a, b) => b.startTime.compareTo(a.startTime));
        break;
      case MatchFilterType.hasNotUploaded:
        for (MatchData matchData in filteredMatches.toList()) {
          if (matchData.hasNotSavedToCloud.isFalse) {
            filteredMatches.remove(matchData);
            filteredMatches.insert(0, matchData);
          }
        }
        break;
    }

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
