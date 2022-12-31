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
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text("Manage all the services this app depends on. Refreshing gets the latest content from the server."),
          ),
          Obx(
            () => Expanded(
              child: ListView.builder(
                itemCount: controller.serviceHelper.services.length,
                itemBuilder: (context, index) {
                  final helper = controller.serviceHelper.services[index];

                  return serviceRow(helper);
                },
              ),
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: ElevatedButton(
                  child: const Text("Force Refresh All"),
                  onPressed: () {
                    controller.serviceHelper.forceRefreshAll();
                  },
                ),
              )),
        ],
      ),
    );
  }

  Obx serviceRow(ServiceClass helper) {
    return Obx(
      () => Expanded(
        child: ListTile(
          title: Text(helper.service.value.name.value),
          subtitle: Row(children: [
            Text(
              helper.service.value.status.value.longString,
              style: TextStyle(color: helper.service.value.status.value.color),
            ),
            Text(" • ${helper.service.value.message.value}")
          ]),
          trailing: IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => helper.forceRefresh(),
          ),
        ),
      ),
    );
  }
}
