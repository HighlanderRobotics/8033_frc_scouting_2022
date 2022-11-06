import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frc_scouting/getx_screens/post_game_screen.dart';
import 'package:frc_scouting/services/event_types.dart';
import 'package:get/get.dart';
import '../services/draggable_floating_action_button.dart';
import '../services/getx_business_logic.dart';

class GameScreen extends StatelessWidget {
  final BusinessLogicController c = Get.find();

  var robotIsImmobile = false.obs;

  void move() {
    Get.to(() => PostGameScreen());
  }

  final GlobalKey _parentKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    c.startGameScreenTimer();

    return Scaffold(
      body: paintWidget(context),
    );
  }

  Container paintWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/gameboard_cropped.png'),
          alignment: Alignment.center,
        ),
      ),
      child: Stack(
        key: _parentKey,
        children: [
          InkWell(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            onTap: () => c.addEvent(EventType.shotSuccess, 3),
            onLongPress: () => c.addEvent(EventType.shotMiss, 3),
          ),
          Align(
            alignment: Alignment.center,
            child: createCustomEventWidget(0, BoxShape.circle, 250, 250),
          ),
          Positioned(
            top: 70,
            left: 70,
            child: createCustomEventWidget(1, BoxShape.rectangle, 100, 100),
          ),
          Positioned(
            bottom: 70,
            right: 70,
            child: createCustomEventWidget(1, BoxShape.rectangle, 100, 100),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            child: createCustomEventWidget(2, BoxShape.rectangle, 120, 120),
          ),
          Positioned(
            top: 10,
            right: 0,
            child: createCustomEventWidget(2, BoxShape.rectangle, 120, 120),
          ),
          draggableFloatingActionButtonWidget(),
        ],
      ),
    );
  }

  Widget draggableFloatingActionButtonWidget() {
    return Obx(
      () => DraggableFloatingActionButton(
        initialOffset: const Offset(120, 70),
        parentKey: _parentKey,
        onPressed: () {
          c.addEvent(EventType.robotBecomesImmobile, 5);
          robotIsImmobile.toggle();
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
              Icon(robotIsImmobile.isTrue
                  ? CupertinoIcons.heart_slash
                  : CupertinoIcons.heart),
              Text(
                robotIsImmobile.isTrue ? "Robot\nBroke" : "Robot\nMobile",
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
          color: Colors.red.withOpacity(0.7),
        ),
      ),
      onTap: () => c.addEvent(EventType.shotSuccess, position),
      onLongPress: () => c.addEvent(EventType.shotMiss, position),
    );
  }
}
