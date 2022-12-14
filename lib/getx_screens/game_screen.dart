import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frc_scouting/getx_screens/post_game_screen.dart';
import 'package:frc_scouting/models/game_screen_positions.dart';
import 'package:get/get.dart';
import '../models/event_types.dart';
import '../services/draggable_floating_action_button.dart';
import '../services/getx_business_logic.dart';

class GameScreen extends StatelessWidget {
  final BusinessLogicController controller = Get.find();

  var robotIsMobile = true.obs;

  final GlobalKey draggableFABParentKey = GlobalKey();

  double calculateBoxDecorationHeight() =>
      (Get.mediaQuery.size.width * 1620) / 3240;

  double calculateDeviceVerticalEdgeToBoxDecorationHeight() =>
      (Get.mediaQuery.size.height - calculateBoxDecorationHeight()) / 2;

  Timer timer = Timer(150.seconds, () => Get.to(() => PostGameScreen()));

  @override
  Widget build(BuildContext context) {
    controller.setLandscapeOrientation();

    return WillPopScope(
      onWillPop: () async {
        timer.cancel();
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
              timer.cancel();
              HapticFeedback.heavyImpact();
              Get.to(() => PostGameScreen());
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
          image: AssetImage('assets/field22.png'),
          alignment: Alignment.center,
          fit: BoxFit.fitWidth,
        ),
        color: Colors.grey[850],
      ),
      child: Stack(
        key: draggableFABParentKey,
        children: [
          InkWell(
            child: SizedBox(
              width: Get.mediaQuery.size.width,
              height: Get.mediaQuery.size.height,
            ),
            onTap: () {
              controller.addEvent(
                  EventType.shotSuccess, GameScreenPosition.field);
              HapticFeedback.lightImpact();
            },
            onLongPress: () {
              controller.addEvent(EventType.shotMiss, GameScreenPosition.field);
              HapticFeedback.heavyImpact();
            },
          ),
          Align(
            alignment: Alignment.center,
            child: createCustomEventWidget(
              GameScreenPosition.hub,
              BoxShape.circle,
              calculateBoxDecorationHeight(),
              calculateBoxDecorationHeight(),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: createCustomEventWidget(
              GameScreenPosition.tarmac,
              BoxShape.circle,
              calculateBoxDecorationHeight() * 0.5,
              calculateBoxDecorationHeight() * 0.5,
            ),
          ),
          Positioned(
            top: calculateDeviceVerticalEdgeToBoxDecorationHeight(),
            left: 0,
            child: createCustomEventWidget(
                GameScreenPosition.fieldEnd,
                BoxShape.rectangle,
                calculateBoxDecorationHeight() * 0.4,
                Get.mediaQuery.size.height -
                    (calculateDeviceVerticalEdgeToBoxDecorationHeight() * 2)),
          ),
          Positioned(
            top: calculateDeviceVerticalEdgeToBoxDecorationHeight(),
            right: 0,
            child: createCustomEventWidget(
                GameScreenPosition.fieldEnd,
                BoxShape.rectangle,
                calculateBoxDecorationHeight() * 0.4,
                Get.mediaQuery.size.height -
                    (calculateDeviceVerticalEdgeToBoxDecorationHeight() * 2)),
          ),
          Positioned(
            top: calculateDeviceVerticalEdgeToBoxDecorationHeight(),
            left: Get.mediaQuery.size.width * 0.14,
            child: createCustomEventWidget(
              GameScreenPosition.launchpad,
              BoxShape.rectangle,
              calculateBoxDecorationHeight() * 0.25,
              calculateBoxDecorationHeight() * 0.5,
            ),
          ),
          Positioned(
            bottom: calculateDeviceVerticalEdgeToBoxDecorationHeight(),
            right: Get.mediaQuery.size.width * 0.14,
            child: createCustomEventWidget(
              GameScreenPosition.launchpad,
              BoxShape.rectangle,
              calculateBoxDecorationHeight() * 0.25,
              calculateBoxDecorationHeight() * 0.5,
            ),
          ),
          draggableFloatingActionButtonWidget(),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Team: ${controller.matchData.teamNumber.toString()}",
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget draggableFloatingActionButtonWidget() {
    const radius = 50.0;

    return Obx(
      () => DraggableFloatingActionButton(
        initialOffset: const Offset(20, 20),
        parentKey: draggableFABParentKey,
        onPressed: () {
          robotIsMobile.toggle();
          controller.addEvent(
              robotIsMobile.isTrue
                  ? EventType.robotBecomesMobile
                  : EventType.robotBecomesImmobile,
              GameScreenPosition.none);
        },
        child: Container(
          width: radius,
          height: radius,
          decoration: ShapeDecoration(
            shadows: [
              BoxShadow(
                color: Colors.orange.shade300,
                blurRadius: 15,
                spreadRadius: 1,
              ),
            ],
            shape: const CircleBorder(),
            color: Colors.orange.shade200,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                robotIsMobile.isTrue
                    ? "assets/robotEnabledIcon.png"
                    : "assets/robotDisabledIcon.png",
              )
            ],
          ),
        ),
      ),
    );
  }

  InkWell createCustomEventWidget(GameScreenPosition position,
      BoxShape boxShape, double width, double height) {
    return InkWell(
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          shape: boxShape == BoxShape.circle
              ? const CircleBorder()
              : const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
          color: Colors.deepPurple.withOpacity(0.5),
        ),
      ),
      onTap: () {
        controller.addEvent(EventType.shotSuccess, position);
        HapticFeedback.lightImpact();
      },
      onLongPress: () {
        controller.addEvent(EventType.shotMiss, position);
        HapticFeedback.heavyImpact();
      },
    );
  }
}
