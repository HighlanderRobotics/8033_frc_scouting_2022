import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frc_scouting/application/color_schemes.g.dart';
import 'package:frc_scouting/getx_screens/home_screen.dart';
import 'package:frc_scouting/getx_screens/settings_screen.dart';
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
      navigatorObservers: [ResetScreenOrientationObserver()],
    ),
  );
}

class ResetScreenOrientationObserver extends GetObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    // check if the popped route is the settings screen

    final routes = [
      "/SettingsScreen",
      "/GameScreen",
      "/GameConfigurationScreen",
      "/PreviousMatchScreen"
    ];

    if (routes.contains(route.settings.name)) {
      Fluttertoast.cancel();
      
      SystemChrome.setPreferredOrientations(
        [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ],
      );

      SystemChrome.setPreferredOrientations(
        [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
      );
    }

    super.didPop(route, previousRoute);
  }
}
