import 'package:flutter/material.dart';
import 'package:frc_scouting/getx_screens/home_screen.dart';
import 'package:get/get.dart';

void main() {
  runApp(
    GetMaterialApp(
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: HomeScreen(),
    ),
  );
}
