import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class NavHelper {
  static void popLastScreens<T>({
    int popCount = 1,
    T? result,
  }) {
    int count = 0;
    while (count < popCount) {
      Get.back(result: result);
      count++;
    }
  }

  static void popToRoot() {
    Get.offAllNamed('/');
  }

  static void popOffScreen(String routeName) {
    Get.offAllNamed(routeName);
  }

  static void pushToNamed(String routeName) {
    Get.toNamed(routeName);
  }

  static void offAllToNamed(String routeName) {
    Get.offAllNamed(routeName);
  }

  static void pushToScreenWithArguments(String routeName, dynamic arguments) {
    Get.toNamed(routeName, arguments: arguments);
  }

  static void pushToScreenWithReplacement(String routeName) {
    Get.offNamed(routeName);
  }

  // static void go(BuildContext context, )
}
