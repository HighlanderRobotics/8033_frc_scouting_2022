import 'package:flutter/material.dart';
import 'package:frc_scouting/services/getx_business_logic.dart';
import 'package:get/get.dart';

import 'game_screen.dart';

class StartCollectionScreen extends StatelessWidget {
  final BusinessLogicController businessController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Start Collection"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Get.to(() => GameScreen());
            },
            child: const Text('Start Collection'),
          )
        ],
      ),
    );
  }
}
