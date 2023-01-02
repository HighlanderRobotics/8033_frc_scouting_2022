import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helpers/match_schedule_helper.dart';
import '../helpers/scouters_helper.dart';
import '../helpers/scouters_schedule_helper.dart';

enum ServiceStatus { error, inProgress, up, unknown }

extension ServiceStatusExtension on ServiceStatus {
  String get longString {
    switch (this) {
      case ServiceStatus.up:
        return "Up";
      case ServiceStatus.error:
        return "Error";
      case ServiceStatus.inProgress:
        return "In Progress";
      case ServiceStatus.unknown:
        return "Unknown";
    }
  }

  Color get color {
    switch (this) {
      case ServiceStatus.up:
        return Colors.green;
      case ServiceStatus.error:
        return Colors.red;
      case ServiceStatus.inProgress:
        return Colors.orange;
      case ServiceStatus.unknown:
        return Colors.grey;
    }
  }
}

class Service {
  var name = "".obs;

  var status = ServiceStatus.unknown.obs;
  var message = "".obs;

  void updateStatus(ServiceStatus newStatus, String newMessage) {
    status.value = newStatus;
    message.value = newMessage;
  }

  Service({String name = ""}) {
    this.name.value = name;
  }
}

abstract class ServiceClass {
  var service = Service().obs;

  void refresh({required bool networkRefresh});
}

class ServiceHelper {
  final RxList<ServiceClass> services = [
    MatchScheduleHelper.shared,
    ScoutersHelper.shared,
    ScoutersScheduleHelper.shared,
  ].obs;

  void refreshAll({bool networkRefresh = false}) {
    for (var service in services) {
      service.refresh(networkRefresh: networkRefresh);
    }
  }

  void forceRefresh(
      {required ServiceClass service, bool networkRefresh = false}) {
    service.refresh(networkRefresh: networkRefresh);
  }

  bool get isAllUp {
    for (var service in services) {
      if (service.service.value.status.value != ServiceStatus.up) {
        return false;
      }
    }

    return true;
  }
}
