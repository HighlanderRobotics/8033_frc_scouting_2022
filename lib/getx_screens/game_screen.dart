import 'package:flutter/material.dart';
import 'package:frc_scouting/getx_screens/post_game_screen.dart';
import 'package:get/get.dart';
import '../services/event.dart';
import '../services/event_types.dart';
import '../services/getx_business_logic.dart';

class GameScreen extends StatelessWidget {
  final BusinessLogicController c = Get.find();

  void move() {
    Get.to(() => PostGameScreen());
  }

  @override
  Widget build(BuildContext context) {
    c.startGameScreenTimer();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: gridView(),
            ),
          ],
        ),
      ),
    );
  }

  InkWell createAddEventButtonWithShotSuccess(int position) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.7),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Text(
          "Add Event ${position}",
          style: TextStyle(fontSize: 20.0),
        ),
      ),
      onTap: () {
        c.addEvent(
            Event(timeSince: 3, type: EventType.shotSuccess, position: 6));
      },
    );
  }

  Container gridView() {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/gameboard_cropped.png'),
              alignment: Alignment.topCenter)),
      child: GridView.count(
        padding: EdgeInsets.all(4.0),
        crossAxisCount: 3,
        shrinkWrap: true,
        childAspectRatio: 1.3,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
          6,
          (index) {
            return Container(
              padding: const EdgeInsets.all(5),
              child: SizedBox(
                height: 200,
                child:
                    Center(child: createAddEventButtonWithShotSuccess(index)),
              ),
            );
          },
        ),
      ),
    );
  }
}
