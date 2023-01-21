import 'package:flutter/material.dart';
import 'package:frc_scouting/application/color_schemes.g.dart';
import 'package:frc_scouting/getx_screens/home_screen.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: lightColorScheme,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
        useMaterial3: true,
      ),
      home: HomeScreen(),
    ),
  );
}
