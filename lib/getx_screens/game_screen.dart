import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frc_scouting/getx_screens/post_game_screen.dart';
import 'package:frc_scouting/services/event_types.dart';
import 'package:get/get.dart';
import '../services/draggable_floating_action_button.dart';
import '../services/getx_business_logic.dart';

class GameScreen extends StatelessWidget {
  final BusinessLogicController c = Get.find();

  var robotIsMobile = true.obs;
  void move() {
    Get.to(() => PostGameScreen());
  }

  final GlobalKey _parentKey = GlobalKey();

  double calculateBoxDecorationHeight() {
    return (Get.mediaQuery.size.width * 662) / 1328;
  }

  double calculateDeviceVerticalEdgeToBoxDecorationHeight() {
    return (Get.mediaQuery.size.height - calculateBoxDecorationHeight()) / 2;
  }

  @override
  Widget build(BuildContext context) {
    print("width: ${Get.mediaQuery.size.width}");
    print("height: ${Get.mediaQuery.size.height}");
    print("DecorationImage Height: ${calculateBoxDecorationHeight()}");
    print(
        "Top to DecorationImage Height: ${calculateDeviceVerticalEdgeToBoxDecorationHeight()}");

    return Scaffold(
      body: paintWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => move(),
        mini: true,
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }

  Container paintWidget() {
    return Container(
      width: Get.mediaQuery.size.width,
      height: Get.mediaQuery.size.height,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/gameboard_cropped.png'),
          alignment: Alignment.center,
          fit: BoxFit.fitWidth,
        ),
      ),
      child: Stack(
        key: _parentKey,
        children: [
          InkWell(
            child: SizedBox(
              width: Get.mediaQuery.size.width,
              height: Get.mediaQuery.size.height,
            ),
            onTap: () => c.addEvent(EventType.shotSuccess, 3),
            onLongPress: () => c.addEvent(EventType.shotMiss, 3),
          ),
          Align(
            alignment: Alignment.center,
            child: createCustomEventWidget(
              0,
              BoxShape.circle,
              calculateBoxDecorationHeight() * 0.9,
              calculateBoxDecorationHeight() * 0.9,
            ),
          ),
          Positioned(
            top: calculateDeviceVerticalEdgeToBoxDecorationHeight() +
                (calculateBoxDecorationHeight() * 0.20),
            left: Get.mediaQuery.size.width * 0.15,
            child: createCustomEventWidget(
              1,
              BoxShape.rectangle,
              calculateBoxDecorationHeight() * 0.25,
              calculateBoxDecorationHeight() * 0.25,
            ),
          ),
          Positioned(
            bottom: calculateDeviceVerticalEdgeToBoxDecorationHeight() +
                (calculateBoxDecorationHeight() * 0.20),
            right: Get.mediaQuery.size.width * 0.15,
            child: createCustomEventWidget(
              1,
              BoxShape.rectangle,
              calculateBoxDecorationHeight() * 0.25,
              calculateBoxDecorationHeight() * 0.25,
            ),
          ),
          Positioned(
            bottom: calculateDeviceVerticalEdgeToBoxDecorationHeight(),
            left: 0,
            child: createCustomEventWidget(2, BoxShape.rectangle, calculateBoxDecorationHeight() * 0.4, calculateBoxDecorationHeight() * 0.4),
          ),
          Positioned(
            top: calculateDeviceVerticalEdgeToBoxDecorationHeight(),
            right: 0,
            child: createCustomEventWidget(2, BoxShape.rectangle, calculateBoxDecorationHeight() * 0.4, calculateBoxDecorationHeight() * 0.4),
          ),
          draggableFloatingActionButtonWidget(),
        ],
      ),
    );
  }

  Widget draggableFloatingActionButtonWidget() {
    return Obx(
      () => DraggableFloatingActionButton(
        initialOffset: const Offset(0, 0),
        parentKey: _parentKey,
        onPressed: () {
          c.addEvent(EventType.robotBecomesImmobile, 5);
          robotIsMobile.toggle();
        },
        child: Container(
          width: 90,
          height: 90,
          decoration: ShapeDecoration(
            shadows: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
            shape: const CircleBorder(),
            color: Colors.amber.shade50,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(robotIsMobile.isTrue
                  ? CupertinoIcons.heart
                  : CupertinoIcons.heart_slash),
              Text(
                robotIsMobile.isTrue ? "Robot\nMobile" : "Robot\nBroke",
                style: const TextStyle(
                  fontSize: 14,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  InkWell createCustomEventWidget(
      int position, BoxShape boxShape, double width, double height) {
    return InkWell(
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: boxShape,
          color: Colors.red.withOpacity(0),
        ),
      ),
      onTap: () => c.addEvent(EventType.shotSuccess, position),
      onLongPress: () => c.addEvent(EventType.shotMiss, position),
    );
  }
}
