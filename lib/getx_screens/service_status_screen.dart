import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/service.dart';
import '../services/getx_business_logic.dart';

class ServiceStatusScreen extends StatelessWidget {
  final BusinessLogicController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Service Status"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("Manage all the services this app depends on."),
            ),
            Obx(
              () => ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.serviceHelper.services.length,
                  itemBuilder: (context, index) =>
                      serviceRow(controller.serviceHelper.services[index])),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      child: const Text("Network Refresh All"),
                      onPressed: () {
                        controller.serviceHelper
                            .refreshAll(networkRefresh: true);
                      },
                    ),
                    ElevatedButton(
                      child: const Text("Storage Refresh All"),
                      onPressed: () {
                        controller.serviceHelper
                            .refreshAll(networkRefresh: false);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Obx serviceRow(ServiceClass helper) {
    return Obx(
      () => ListTile(
        title: Text(helper.service.value.name.value),
        subtitle: Row(children: [
          Text(
            helper.service.value.status.value.longString,
            style: TextStyle(color: helper.service.value.status.value.color),
          ),
          const Text(" • "),
          Flexible(
            fit: FlexFit.loose,
            child: Text(
              helper.service.value.message.value,
              overflow: TextOverflow.ellipsis,
              maxLines: 10,
              textAlign: TextAlign.left,
            ),
          ),
        ]),
        trailing: IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => helper.refresh(networkRefresh: true),
        ),
      ),
    );
  }
}
