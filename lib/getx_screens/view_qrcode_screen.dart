import 'package:flutter/material.dart';
import 'package:frc_scouting/services/getx_business_logic.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';


class QrCodeScreen extends StatelessWidget {
  final BusinessLogicController controller = Get.find();
  var pageNumber = 0.obs;
  late final List<String> matchQrCodes;
  var canGoBack = false;

  QrCodeScreen({required this.matchQrCodes, required this.canGoBack});

  void nextPage() => pageNumber.value =
      (pageNumber.value < matchQrCodes.length - 1) ? pageNumber.value + 1 : 0;

  @override
  Widget build(BuildContext context) {
    controller.setPortraitOrientation();

    return Scaffold(
        appBar: AppBar(
          title: const Text("QR Code"),
          automaticallyImplyLeading: canGoBack,
        ),
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
                      backgroundColor: Colors.white,
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
                      controller.reset();
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
