import 'package:flutter/material.dart';
import 'package:frc_scouting/getx_screens/home_screen.dart';
import 'package:get/get.dart';

void main() {
  runApp(GetMaterialApp(home: HomeScreen()));

  // runApp(MaterialApp(
  //   home: Home(),
  // ));

  // runApp(MaterialApp(
  //   initialRoute: '/',
  //   routes: {
  //     '/': (context) => Loading(),
  //     '/home': (context) => Home(),
  //     '/login': (context) => Login(),
  //     '/data_entry': (context) => DataEntry(),
  //     '/postgame_data_entry': (context) => PostGameData(),
  //     '/start_page': (context) => StartPage(),
  //     '/qrcode_screen': (context) => QRCodeScreen(),
  //     '/text_qrcode_screen': (context) => TextQRCodeScreen(),
  //   },
  // ));
}
