import 'package:flutter/material.dart';
import 'package:frc_scouting/custom_widgets/frc_app_bar.dart';
import 'package:frc_scouting/services/getx_business_logic.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;

class QrCodeScreen extends StatelessWidget {
  final BusinessLogicController c = Get.find();
  var pageNumber = 0.obs;
  late bool dataSaved;
  late final List<String> matchQrCodes;
  var canGoBack = false;

  QrCodeScreen({required this.matchQrCodes, required this.canGoBack});

  void nextPage() => pageNumber.value =
      (pageNumber.value < matchQrCodes.length - 1) ? pageNumber.value + 1 : 0;

  void saveData(BuildContext context) async {
    var client = new http.Client();
    try {

      // Example sending data, the teamkey and tournament key will coorelate to a specific match, which the data will be entered to
      // await client.post(Uri.parse('http://{server ip}/addScoutReport'),
      //  headers: <String, String>{
      //     'Content-Type': 'application/json; charset=UTF-8',
      //  },
      //  body: jsonEncode(<String, String>{
      //    'teamKey': 'frc${gameData.teamNumber}', TODO: idk where gamedata.teamNumber is stored but im sure you got this, just send it here
      //    'tournamentKey': TODO: Preset tournament key
      //    'data': gameData.getData() TODO: Rest of the gamedata can go here
      //   }),
      // );

      var response = await client.get(Uri.parse('http://10.0.0.34:4000/listTeams'));

      if (response.statusCode == 201) {
        print('Its saul goodman');
      }
      if (response.statusCode < 400) {
        Get.snackbar(
          "Upload Successful",
          "Match has uploaded to cloud",
          snackPosition: SnackPosition.BOTTOM,
        );

        // Send another request later with the token as the body to see if data was entered correctly

      } else {
        print('Error with accessing thing');
        Get.snackbar(
            "Upload Not Successful",
            "${response.statusCode}: Could not connect to cloud",
            snackPosition: SnackPosition.BOTTOM,
        );
      }
      // Later would be a token given by the data entry
      print(response.body);
    }
    finally {
      client.close();

      // Save to files aswell
      if (await c.documentsHelper.saveMatchData(c.matchData)) {
        Get.snackbar(
          "Saved Successfully",
          "Match has been saved to the device",
          snackPosition: SnackPosition.TOP,
        );
      }
    }
  }

  @override
  void initState() {
    dataSaved = false;
  }

  @override
  Widget build(BuildContext context) {
    c.setPortraitOrientation();

    saveData(context);

    return Scaffold(


        appBar: scoutingAppBar("QR Code", hideBackButton: canGoBack),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(
            () => ListView(
              children: [
                SafeArea(
                  child: QrImage(
                      data: matchQrCodes[pageNumber.value],
                      version: QrVersions.auto,
                      errorCorrectionLevel: QrErrorCorrectLevel.L,
                      gapless: false,
                      errorStateBuilder: (cxt, err) {
                        return const Center(
                          child: Text(
                            "Uh oh! Something went wrong...",
                            textAlign: TextAlign.center,
                          ),
                        );
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                        "Page ${pageNumber.value + 1} out of ${matchQrCodes.length}"),
                  ),
                ),
                if (matchQrCodes.length > 1)
                  ElevatedButton(
                    onPressed: nextPage,
                    child: const Text("Next Page"),
                  ),
                ElevatedButton(
                  child: Text(canGoBack ? "Back" : "Finish"),
                  onPressed: () {
                    Get.closeCurrentSnackbar();
                    if (canGoBack) {
                      Get.back();
                    } else {
                      c.reset();
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
