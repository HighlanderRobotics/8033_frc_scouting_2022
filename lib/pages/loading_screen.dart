import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/services.dart';
import 'package:frc_scouting/getx_screens/home_screen.dart';
import 'package:get/get.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void getData() async {
    // Waits for screen to build?
    // TODO: Get any api data and load preset data from cloud here
    await Future.delayed(Duration(milliseconds: 1), () {});

    Get.to(() => HomeScreen());
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Loading',
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Center(
            child: SpinKitFadingCube(
              color: Colors.white,
              size: 50,
            ),
          ),
        ],
      ),
    );
  }
}
