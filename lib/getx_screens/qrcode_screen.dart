import 'package:flutter/material.dart';
import 'package:frc_scouting/services/getx_business_logic.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeScreen extends StatelessWidget {
  final BusinessLogicController c = Get.find();
  var pageNumber = 0.obs;
  late final List<String> QrCodes;

  void nextPage() => pageNumber.value =
      (pageNumber.value < QrCodes.length - 1) ? pageNumber.value + 1 : 0;

  @override
  Widget build(BuildContext context) {
    QrCodes = c.matchData.value.separateEventsToQrCodes();

    return Scaffold(
        appBar: AppBar(title: Text("QR Code")),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(
            () => ListView(
              children: [
                QrImage(
                    data: QrCodes[pageNumber.value],
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
                Center(
                  child: Text(
                      "Page ${pageNumber.value + 1} out of ${QrCodes.length}"),
                ),
                ElevatedButton(
                  child: Text("Next"),
                  onPressed: () => nextPage(),
                ),
                ElevatedButton(
                  child: Text("Done"),
                  onPressed: () => c.reset(),
                ),
              ],
            ),
          ),
        ));
  }
}
