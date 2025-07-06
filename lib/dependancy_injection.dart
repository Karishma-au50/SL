import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'shared/services/common_service.dart';
import 'shared/services/notification_service.dart';
import 'shared/services/storage_service.dart';

class DependancyInjection {
  static Future init() async {
    try {
      await StorageService().init();
      await Get.putAsync(() => CommonService().init());
      // Get.put(VideoController(), permanent: true, tag: "GLOBAL");
      // NotificationService();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
