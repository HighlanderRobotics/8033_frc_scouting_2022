import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:holding_gesture/holding_gesture.dart';

import 'game_configuration_screen.dart';
import '../models/levels.dart';
import 'package:get/get.dart';

import '../models/object_type.dart';
import '../models/robot_action.dart';
import 'post_game_screen.dart';

import '../services/draggable_floating_action_button.dart';
import '../services/getx_business_logic.dart';
import 'settings_screen.dart';

class GameScreenObject {
  Size size;
  int position;

  GameScreenObject({required this.size, required this.position});
}

class GameScreen extends StatelessWidget {
  final BusinessLogicController controller = Get.find();
  final SettingsScreenVariables variables = Get.find();

  GameScreen({required this.isInteractive});

  final bool isInteractive;

  var isRobotCarryingCargo = true.obs;
  var isRobotDefending = false.obs;
  var isCommunityEntranceObjectsHidden = false.obs;

  final GlobalKey draggableFABParentKey = GlobalKey();

  Size get boxDecorationSize {
    return Size(
      Get.mediaQuery.size.width -
          Get.mediaQuery.padding.left -
          Get.mediaQuery.padding.right,
      ((Get.mediaQuery.size.width -
                  Get.mediaQuery.padding.top -
                  Get.mediaQuery.padding.bottom) *
              1620) /
          3240,
    );
  }

  double getTopToBoxDecorationHeight() =>
      ((Get.mediaQuery.size.height - boxDecorationSize.height) / 2) +
      Get.mediaQuery.padding.top;

  double getBottomToBoxDecorationHeight() =>
      ((Get.mediaQuery.size.height - boxDecorationSize.height) / 2) +
      Get.mediaQuery.padding.bottom;

  Timer presentPostGameScreenTimer = Timer(150.seconds, () {});
  Timer autoTimer = Timer(17.seconds, () {});

  final communityEntranceRectangleValues = [
    GameScreenObject(size: const Size(0.345, 0.130), position: 10),
    GameScreenObject(size: const Size(0.480, 0.355), position: 11),
    GameScreenObject(size: const Size(0.840, 0.130), position: 12),
  ];

  var midFieldCargoValues = [
    GameScreenObject(size: const Size(0.408, 0.530), position: 13),
    GameScreenObject(size: const Size(0.408, 0.385), position: 14),
    GameScreenObject(size: const Size(0.408, 0.235), position: 15),
    GameScreenObject(size: const Size(0.408, 0.087), position: 16),
    GameScreenObject(size: const Size(0.553, 0.530), position: 17),
    GameScreenObject(size: const Size(0.553, 0.385), position: 18),
    GameScreenObject(size: const Size(0.553, 0.235), position: 19),
    GameScreenObject(size: const Size(0.553, 0.087), position: 20),
  ].obs;

  @override
  Widget build(BuildContext context) {
    controller.setLandscapeOrientation();

    controller.matchData.startTime = DateTime.now();
    controller.matchData.events.value = [];

    presentPostGameScreenTimer.cancel();
    autoTimer.cancel();

    if (isInteractive) {
      presentPostGameScreenTimer = Timer(150.seconds, () {
        if (isInteractive) {
          HapticFeedback.mediumImpact();
          Get.to(() => PostGameScreen());
        }
      });
      autoTimer = Timer(17.seconds, () {
        if (isInteractive) {
          HapticFeedback.mediumImpact();
          isCommunityEntranceObjectsHidden.value = true;
        }
      });
    }

    return WillPopScope(
      onWillPop: () async {
        presentPostGameScreenTimer.cancel();
        autoTimer.cancel();
        controller.resetOrientation();
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          // keep the bottom and top safe area insets the same
          bottom: true,
          top: true,
          child: paintWidget(),
        ),
        floatingActionButton: !isInteractive
            ? null
            : FloatingActionButton(
                onPressed: null,
                mini: true,
                child: GestureDetector(
                  child: const Icon(Icons.arrow_forward),
                  onLongPress: () {
                    if (isInteractive) {
                      presentPostGameScreenTimer.cancel();
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
            Positioned(
              top: getTopToBoxDecorationHeight(),
              child: SizedBox(
                  width: Get.mediaQuery.size.width,
                  height: 1,
                  child: Container(color: Colors.red)),
            ),
            Positioned(
              bottom: getBottomToBoxDecorationHeight(),
              child: SizedBox(
                  width: Get.mediaQuery.size.width,
                  height: 1,
                  child: Container(color: Colors.red)),
            ),
            for (final index in gridRectangleValues)
              createGridRectangle(index: index),
            if (isCommunityEntranceObjectsHidden.isFalse &&
                isInteractive == true)
              for (final index in communityEntranceRectangleValues)
                createCommunityEntranceMethodRectangle(object: index),
            for (final index in midFieldCargoValues)
              createFieldCargoCircle(index),
            if (isInteractive)
              draggableFloatingActionButtonWidget(
                icon: Icon(
                  isRobotCarryingCargo.isTrue
                      ? CupertinoIcons.bag_badge_minus
                      : CupertinoIcons.bag_badge_plus,
                  size: 35,
                  color: Colors.white,
                ),
                initialOffset: Offset(boxDecorationSize.width - 70, 0),
                onTapAction: () {
                  if (isRobotCarryingCargo.isTrue) {
                    HapticFeedback.mediumImpact();

                    controller.addEventToTimeline(
                      robotAction: RobotAction.droppedObject,
                      position: 0,
                    );

                    isRobotCarryingCargo.value = false;
                  } else {
                    showDialog(
                      context: Get.context!,
                      builder: (context) => createGameImmersiveDialog(
                        widgets: ObjectType.values
                            .map((objectType) =>
                                objectDialogRectangle(objectType))
                            .toList(),
                        context: context,
                      ),
                    );
                  }
                },
              ),
            createSubstationRectangle(),
            if (isInteractive)
              draggableFloatingActionButtonWidget(
                  // access the material symbol "conveyor_belt
                  icon: const Icon(Icons.bluetooth),
                  initialOffset: Offset(boxDecorationSize.width - 100, 0)),
            if (isInteractive)
              HoldTimeoutDetector(
                enableHapticFeedback: true,
                onTimeout: () {},
                onTap: () {},
                onTimerInitiated: () {
                  isRobotDefending.value = true;
                  controller.addEventToTimeline(
                      robotAction: RobotAction.startDefense, position: 0);
                  HapticFeedback.mediumImpact();
                },
                onCancel: () {
                  isRobotDefending.value = false;
                  controller.addEventToTimeline(
                      robotAction: RobotAction.endDefense, position: 0);
                  HapticFeedback.mediumImpact();
                },
                child: draggableFloatingActionButtonWidget(
                  color: isRobotDefending.isTrue ? Colors.red : Colors.black,
                  icon: Icon(
                    isRobotDefending.isTrue
                        ? CupertinoIcons.shield
                        : CupertinoIcons.shield_fill,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
              ),
            if (isInteractive)
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
    required GameScreenObject object,
  }) {
    return Positioned(
      top: getTopToBoxDecorationHeight() +
          boxDecorationSize.height * object.size.width,
      left: variables.rotation.value == GameConfigurationRotation.left
          ? boxDecorationSize.width * 0.185
          : null,
      right: variables.rotation.value == GameConfigurationRotation.right
          ? boxDecorationSize.width * 0.185
          : null,
      child: InkWell(
        child: Obx(
          () => createCustomEventWidget(
            boxShape: BoxShape.rectangle,
            width: boxDecorationSize.height * 0.2,
            height: boxDecorationSize.height * object.size.height,
            isDisabled: isCommunityEntranceObjectsHidden.isTrue,
          ),
        ),
        onTap: () {
          if (isCommunityEntranceObjectsHidden.isFalse) {
            HapticFeedback.mediumImpact();
            controller.addEventToTimeline(
              robotAction: RobotAction.crossedCommunityLine,
              position: object.position,
            );
          }
        },
      ),
    );
  }

  Positioned createFieldCargoCircle(GameScreenObject object) {
    return Positioned(
      left: boxDecorationSize.width * object.size.width - 4,
      bottom: getBottomToBoxDecorationHeight() +
          boxDecorationSize.height * object.size.height -
          4,
      child: InkWell(
        child: Obx(
          () => createCustomEventWidget(
            boxShape: BoxShape.circle,
            width: boxDecorationSize.width * 0.05,
            height: boxDecorationSize.width * 0.05,
            isDisabled: isRobotCarryingCargo.isTrue,
          ),
        ),
        onTap: () {
          if (isRobotCarryingCargo.isFalse || isInteractive == false) {
            showDialog(
              context: Get.context!,
              builder: (context) => createGameImmersiveDialog(
                widgets: ObjectType.values
                    .map((objectType) => objectDialogRectangle(
                          objectType,
                          position: object.position,
                        ))
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
      left:
          variables.rotation.value == GameConfigurationRotation.left ? 0 : null,
      right: variables.rotation.value == GameConfigurationRotation.right
          ? 0
          : null,
      top: getTopToBoxDecorationHeight(),
      child: InkWell(
        child: Obx(
          () => createCustomEventWidget(
            boxShape: BoxShape.rectangle,
            width: boxDecorationSize.width * 0.2,
            height: boxDecorationSize.height * 0.3,
            isDisabled: isRobotCarryingCargo.isTrue,
          ),
        ),
        onTap: () {
          if (isRobotCarryingCargo.isFalse && isInteractive == true) {
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
      bottom: getBottomToBoxDecorationHeight() +
          boxDecorationSize.height * index * 0.22,
      left:
          variables.rotation.value == GameConfigurationRotation.left ? 0 : null,
      right: variables.rotation.value == GameConfigurationRotation.right
          ? 0
          : null,
      child: InkWell(
        child: Obx(
          () => createCustomEventWidget(
            boxShape: BoxShape.rectangle,
            width: boxDecorationSize.height * 0.35,
            height: boxDecorationSize.height * 0.218,
            isDisabled: isRobotCarryingCargo.isFalse,
          ),
        ),
        onTap: () {
          if (isRobotCarryingCargo.isTrue && isInteractive == true) {
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

  Widget draggableFloatingActionButtonWidget({
    Offset initialOffset = Offset.zero,
    void Function()? onTapAction,
    void Function()? onLongPressAction,
    Color color = Colors.black,
    required Widget icon,
  }) {
    return DraggableFloatingActionButton(
      initialOffset: initialOffset,
      parentKey: draggableFABParentKey,
      onPressed: () {},
      child: InkWell(
        onTap: onTapAction,
        onLongPress: onLongPressAction,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: icon,
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
            icon: const Icon(Icons.close, size: 50),
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
            HapticFeedback.mediumImpact();

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

  Widget objectDialogRectangle(ObjectType objectType, {int position = 0}) {
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
              HapticFeedback.mediumImpact();

              controller.addEventToTimeline(
                robotAction: objectType == ObjectType.cube
                    ? RobotAction.pickedUpCube
                    : RobotAction.pickedUpCone,
                position: position,
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
