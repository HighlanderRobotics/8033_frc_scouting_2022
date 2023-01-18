import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frc_scouting/models/match_data.dart';
import 'package:frc_scouting/models/previous_matches_info.dart';
import 'package:frc_scouting/persistence/files_helper.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';

import '../models/match_key.dart';
import 'view_qrcode_screen.dart';
import '../services/getx_business_logic.dart';

class PreviousMatchesScreen extends StatelessWidget {
  final BusinessLogicController controller = Get.find();
  final txtEditingController = TextEditingController();

  late Rx<PreviousMatchesInfo> previousMatchesInfo;
  late final RxList<MatchData> filteredMatches = <MatchData>[].obs;

  var isDismissThresholdReached = false.obs;

  PreviousMatchesScreen({required PreviousMatchesInfo previousMatchesInfo}) {
    this.previousMatchesInfo = previousMatchesInfo.obs;
  }

  @override
  Widget build(BuildContext context) {
    print("Files Directory: ${controller.documentsHelper.directory.path}");
    print(
        "Number of valid matches: ${previousMatchesInfo.value.validMatches.length} out of ${previousMatchesInfo.value.validMatches.length + previousMatchesInfo.value.numberOfInvalidFiles}");
    controller.resetOrientation();

    filterSearchResultsAndUpdateList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Previous Matches"),
      ),
      body: previousMatchesInfo.value.validMatches.isNotEmpty ||
              filteredMatches.isNotEmpty
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
        title: Text(filter.localizedDescription),
        trailing: controller.matchFilterType.value == filter
            ? const Icon(Icons.check)
            : null,
      ),
    );
  }

  Widget previousMatchesListView() {
    return WillPopScope(
      onWillPop: () async {
        Get.closeCurrentSnackbar();
        return true;
      },
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10),
          child: TextField(
            onChanged: (_) => filterSearchResultsAndUpdateList(),
            controller: txtEditingController,
            decoration: InputDecoration(
                labelText: "Search",
                hintText: "Search by Match or Team ",
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
                      curve: Curves.easeInOut,
                      animation: animation,
                      child: Dismissible(
                        onUpdate: (details) {
                          isDismissThresholdReached.value = details.reached;

                          if ((details.reached && !details.previousReached) ||
                              (!details.reached && details.previousReached)) {
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
                                  "Deleted ${matchData.matchKey.value.localizedDescription}"),
                              action: SnackBarAction(
                                label: "Undo",
                                onPressed: () async {
                                  await controller.documentsHelper
                                      .saveAndUploadMatchData(matchData);
                                  await controller.documentsHelper
                                      .getPreviousMatches();
                                  filterSearchResultsAndUpdateList();
                                },
                              ),
                              duration: 3.seconds,
                            ),
                          );
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
                        child:
                            matchRowView(matchData, matchData.matchKey.value),
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

  Widget matchRowView(MatchData matchData, MatchKey matchKey) {
    return InkWell(
      child: ListTile(
        onTap: () => Get.to(
          () => QrCodeScreen(
            matchQrCodes: controller.separateEventsToQrCodes(matchData),
            canPopScope: true,
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
                  Text(matchKey.localizedDescription,
                      style: const TextStyle(fontSize: 18)),
                  Text(
                    "Team: ${matchData.teamNumber.value}",
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
            Obx(
              () => IconButton(
                icon: Icon(matchData.hasSavedToCloud.isTrue
                    ? Icons.cloud_done
                    : Icons.cloud_off),
                onPressed: () async {
                  await controller.documentsHelper.deleteFile(matchData.uuid);
                  await controller.documentsHelper.writeToFile(matchData);
                  if (matchData.hasSavedToCloud.isTrue) {
                    Get.snackbar(
                      "Match Already Uploaded",
                      "Match ${matchData.matchKey.value.localizedDescription} has been uploaded to the cloud",
                      duration: const Duration(seconds: 2),
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  } else {
                    controller.documentsHelper
                        .saveAndUploadMatchData(matchData)
                        .then((uploadStatus) {
                      filterSearchResultsAndUpdateList();
                      Get.snackbar(
                        "Match Uploaded ${uploadStatus ? "Successfully" : "Unsuccessfully"}",
                        "Match ${matchData.matchKey.value.localizedDescription} has ${uploadStatus ? "uploaded" : "failed to upload"} to the cloud",
                        duration: const Duration(seconds: 2),
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    });
                  }
                },
              ),
            ),
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
    filteredMatches.value = previousMatchesInfo.value.validMatches;

    if (txtEditingController.text.isNotEmpty) {
      filteredMatches.value = previousMatchesInfo.value.validMatches
          .where((element) =>
              element.matchKey.toString().contains(txtEditingController.text))
          .toList();
    } else {
      filteredMatches.value = previousMatchesInfo.value.validMatches;
    }

    switch (controller.matchFilterType.value) {
      case MatchFilterType.date:
        filteredMatches.sort((a, b) => b.startTime.compareTo(a.startTime));
        break;
      case MatchFilterType.hasNotUploaded:
        for (MatchData matchData in filteredMatches.toList()) {
          if (matchData.hasSavedToCloud.isFalse) {
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
