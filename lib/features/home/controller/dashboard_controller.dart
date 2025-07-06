import 'package:get/get.dart';

import '../../../model/user_model.dart';
import '../../../shared/services/storage_service.dart';
import '../api/dashboard_services.dart';

class DashboardController extends GetxController {
  final _api = DashboardService();
  Rx<UserModel?> userModel = StorageService.instance.getUserId().obs;

  void setUser(UserModel? user) {
    userModel.value = user;
    update();
    userModel.refresh();
  }

  // Future<List<CategoryModel>?> getCategories() async {
  //   try {
  //     final res = await _api.getCategories();
  //       if (res.status ?? false) {
  //        category(res.data);
  //       }
  //     return res.data;
  //   } catch (e) {
  //     return null;
  //   }
  // }

 
}
