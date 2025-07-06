import 'package:get/get.dart';

import '../../../core/network/base_api_service.dart';
import '../../../shared/constant/enums.dart';
import '../../../shared/services/storage_service.dart';


class DashboardEndpoint {
  static const String user = '/users';
}

class DashboardService extends BaseApiService {
  Rx<UserType> userType = UserType.guest.obs;
  String userId = "";

  Future<void> updateDeviceToken(String token) async {
    StorageService.instance.getUserId()?.id == null
        ? null
        : await post('/sns/addEndpointForUser', data: {
            "token": token,
            "userId": StorageService.instance.getUserId()?.id,
          });
  }


}
