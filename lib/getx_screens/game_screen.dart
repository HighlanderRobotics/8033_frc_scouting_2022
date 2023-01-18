import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frc_scouting/getx_screens/game_configuration_screen.dart';
import 'package:frc_scouting/models/levels.dart';
import 'package:get/get.dart';

import '../models/object_type.dart';
import '../models/robot_action.dart';
import 'post_game_screen.dart';

import '../services/draggable_floating_action_button.dart';
import '../services/getx_business_logic.dart';

class GameScreen extends StatelessWidget {
  GameScreen({
    bool isInteractive = true,
    required this.rotation,
  }) {
    isInteractive = isInteractive;
  }

  final BusinessLogicController controller = Get.find();

  final GameConfigurationRotation rotation;
  final isInteractive = false;

  var isRobotCarryingCargo = true.obs;
  var isCommunityEntranceObjectsHidden = false.obs;

  final GlobalKey draggableFABParentKey = GlobalKey();

  double getBoxDecorationHeight() => (Get.mediaQuery.size.width * 1620) / 3240;

  double getDeviceVerticalEdgeToBoxDecorationHeight() =>
      (Get.mediaQuery.size.height - getBoxDecorationHeight()) / 2;

  Timer timer = Timer(150.seconds, () => Get.to(() => PostGameScreen()));
  Timer autoTimer = Timer(17.seconds, () {});

  final double positionedWidgetMultiplier = 0.22;

  final communityEntranceRectangleValues = [
    [0.345, 0.130],
    [0.480, 0.355],
    [0.840, 0.130],
  ];

  final fieldCargoCircleValues = [
    [0.408, 0.530],
    [0.408, 0.385],
    [0.408, 0.235],
    [0.408, 0.087],
    [0.553, 0.530],
    [0.553, 0.385],
    [0.553, 0.235],
    [0.553, 0.087],
  ];

  @override
  Widget build(BuildContext context) {
    controller.setLandscapeOrientation();

    autoTimer.cancel();

    if (isInteractive) {
      autoTimer = Timer(17.seconds, () {
        HapticFeedback.mediumImpact();
        isCommunityEntranceObjectsHidden.value = true;
      });
    }

    return WillPopScope(
      onWillPop: () async {
        timer.cancel();
        autoTimer.cancel();
        controller.resetOrientation();
        return true;
      },
      child: Scaffold(
        body: paintWidget(),
        floatingActionButton: FloatingActionButton(
          onPressed: null,
          mini: true,
          child: GestureDetector(
            child: const Icon(Icons.arrow_forward),
            onLongPress: () {
              if (isInteractive) {
                timer.cancel();
                autoTimer.cancel();
                HapticFeedback.heavyImpact();
                Get.to(() => PostGameScreen());
              }
            },
          ),
        ),
      ),
    );
  }

  Container paintWidget() {
    return Container(
      width: Get.mediaQuery.size.width,
      height: Get.mediaQuery.size.height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/field23.png'),
          alignment: Alignment.center,
          fit: BoxFit.fitWidth,
          opacity: 0.4,
        ),
        color: Colors.grey[850],
      ),
      child: Obx(
        () => Stack(
          key: draggableFABParentKey,
          children: [
            // TODO: Get rotation direction from GameScreen Configration

            for (final index in gridRectangleValues)
              createGridRectangle(index: index),

            if (isCommunityEntranceObjectsHidden.isFalse &&
                isInteractive == false)
              for (final index in communityEntranceRectangleValues)
                createCommunityEntranceMethodRectangle(index: index),

            for (final index in fieldCargoCircleValues)
              createFieldCargoCircle(index),
            draggableFloatingActionButtonWidget(),
            createSubstationRectangle(),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Team: ${controller.matchData.teamNumber.toString()} • ${isCommunityEntranceObjectsHidden.isTrue ? "Teleop" : "Auto"}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      shadows: [Shadow(blurRadius: 15)]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Positioned createCommunityEntranceMethodRectangle({
    required List<double> index,
  }) {
    return Positioned(
      top: getDeviceVerticalEdgeToBoxDecorationHeight() +
          getBoxDecorationHeight() * index[0],
      left: rotation == GameConfigurationRotation.left
          ? Get.mediaQuery.size.width * 0.185
          : null,
      right: rotation == GameConfigurationRotation.right
          ? Get.mediaQuery.size.width * 0.185
          : null,
      child: InkWell(
        child: Obx(
          () => createCustomEventWidget(
            boxShape: BoxShape.rectangle,
            width: getBoxDecorationHeight() * 0.2,
            height: getBoxDecorationHeight() * index[1],
            isDisabled: isCommunityEntranceObjectsHidden.isTrue,
          ),
        ),
        onTap: () {
          if (isCommunityEntranceObjectsHidden.isFalse) {
            HapticFeedback.mediumImpact();
            controller.addEventToTimeline(
              robotAction: RobotAction.crossedCommunityLine,
              position: 0,
            );
          }
        },
      ),
    );
  }

  Positioned createFieldCargoCircle(List<double> index) {
    return Positioned(
      left: Get.mediaQuery.size.width * index[0] - 4,
      bottom: getDeviceVerticalEdgeToBoxDecorationHeight() +
          getBoxDecorationHeight() * index[1] -
          4,
      child: InkWell(
        child: Obx(
          () => createCustomEventWidget(
            boxShape: BoxShape.circle,
            width: Get.mediaQuery.size.width * 0.05,
            height: Get.mediaQuery.size.width * 0.05,
            isDisabled: isRobotCarryingCargo.isTrue,
          ),
        ),
        onTap: () {
          if (isRobotCarryingCargo.isFalse || isInteractive == false) {
            showDialog(
              context: Get.context!,
              builder: (context) => createGameImmersiveDialog(
                widgets: ObjectType.values
                    .map((objectType) => objectDialogRectangle(objectType))
                    .toList(),
                context: context,
              ),
            );
          }
        },
      ),
    );
  }

  Positioned createSubstationRectangle() {
    return Positioned(
      left: rotation == GameConfigurationRotation.left ? 0 : null,
      right: rotation == GameConfigurationRotation.right ? 0 : null,
      top: getDeviceVerticalEdgeToBoxDecorationHeight(),
      child: InkWell(
        child: Obx(
          () => createCustomEventWidget(
            boxShape: BoxShape.rectangle,
            width: Get.mediaQuery.size.width * 0.2,
            height: getBoxDecorationHeight() * 0.3,
            isDisabled: isRobotCarryingCargo.isTrue,
          ),
        ),
        onTap: () {
          if (isRobotCarryingCargo.isFalse || isInteractive == false) {
            showDialog(
              context: Get.context!,
              builder: (context) => createGameImmersiveDialog(
                widgets: ObjectType.values
                    .map((objectType) => objectDialogRectangle(objectType))
                    .toList(),
                context: context,
              ),
            );
          }
        },
      ),
    );
  }

  final List<int> gridRectangleValues = [0, 1, 2];

  Positioned createGridRectangle({required int index}) {
    return Positioned(
      bottom: getDeviceVerticalEdgeToBoxDecorationHeight() +
          getBoxDecorationHeight() * index * 0.22,
      left: rotation == GameConfigurationRotation.left ? 0 : null,
      right: rotation == GameConfigurationRotation.right ? 0 : null,
      child: InkWell(
        child: Obx(
          () => createCustomEventWidget(
            boxShape: BoxShape.rectangle,
            width: getBoxDecorationHeight() * 0.35,
            height: getBoxDecorationHeight() * 0.218,
            isDisabled: isRobotCarryingCargo.isFalse,
          ),
        ),
        onTap: () {
          if (isRobotCarryingCargo.isTrue) {
            showDialog(
              context: Get.context!,
              builder: (context) => createGameImmersiveDialog(
                widgets: Level.values
                    .map((level) => levelDialogRectangle(level, index + 1))
                    .toList(),
                context: context,
              ),
            );
          }
        },
      ),
    );
  }

  Widget draggableFloatingActionButtonWidget() {
    return Obx(
      () => DraggableFloatingActionButton(
        initialOffset: Offset(Get.mediaQuery.size.width - 70, 20),
        parentKey: draggableFABParentKey,
        onPressed: () {},
        child: InkWell(
          onTap: () {
            if (isRobotCarryingCargo.isTrue) {
              HapticFeedback.mediumImpact();
              controller.addEventToTimeline(
                robotAction: RobotAction.droppedObject,
                position: 0,
              );

              isRobotCarryingCargo.value = false;
            }
          },
          child: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isRobotCarryingCargo.isTrue
                  ? CupertinoIcons.bag_badge_minus
                  : CupertinoIcons.bag_badge_plus,
              size: 35,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget createCustomEventWidget({
    required BoxShape boxShape,
    required double width,
    required double height,
    required bool isDisabled,
  }) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        shape: boxShape == BoxShape.circle
            ? const CircleBorder()
            : const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
        color: Colors.deepPurple.withOpacity(isDisabled ? 0 : 0.8),
      ),
    );
  }

  final Map<int, List<int>> indexToLevelAssociations = {
    1: [1, 4, 7],
    2: [2, 5, 8],
    3: [3, 6, 9],
  };

  Dialog createGameImmersiveDialog({
    required List<Widget> widgets,
    required BuildContext context,
  }) {
    return Dialog(
      child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, right: 8),
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
          ),
        ),
        Expanded(
            child: Row(
          children: widgets,
        )),
      ]),
    );
  }
}

extension GameScreenDialogs on GameScreen {
  Widget levelDialogRectangle(Level level, int index) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 15.0,
          left: 15.0,
          right: 15.0,
          top: 5,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20.0),
          onTap: () {
            level.playHapticFeedback();

            controller.addEventToTimeline(
              robotAction: RobotAction.placedObject,
              position: indexToLevelAssociations[index]![level.index],
            );

            isRobotCarryingCargo.value = false;
            Navigator.of(Get.context!).pop();
          },
          child: Container(
            decoration: BoxDecoration(
                color: level.displayColor,
                borderRadius: const BorderRadius.all(Radius.circular(20.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Level ${level.index}",
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 50),
                    Text(level.localizedDescription,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget objectDialogRectangle(ObjectType objectType) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 15.0,
          left: 15.0,
          right: 15.0,
          top: 5,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20.0),
          onTap: () {
            if (isRobotCarryingCargo.isFalse) {
              objectType.playHapticFeedback();

              controller.addEventToTimeline(
                robotAction: objectType == ObjectType.cube
                    ? RobotAction.pickedUpCube
                    : RobotAction.pickedUpCone,
                position: 0,
              );

              isRobotCarryingCargo.value = true;
              Navigator.of(Get.context!).pop();
            }
          },
          child: Container(
            decoration: BoxDecoration(
                color: objectType.displayBackgroundColor,
                borderRadius: const BorderRadius.all(Radius.circular(20.0))),
            child: Image.asset(objectType.displayImagePath),
          ),
        ),
      ),
    );
  }
}
