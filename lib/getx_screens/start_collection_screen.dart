import 'package:flutter/material.dart';
import 'package:frc_scouting/services/getx_business_logic.dart';
import 'package:get/get.dart';

import 'data_entry_screen.dart';

class StartCollectionScreen extends StatelessWidget {
  final BusinessLogicController c = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Start Collection')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Get.to(DataEntryScreen());
              },
              child: const Text('Start Collection'),
            )
          ],
        ));
  }
}
