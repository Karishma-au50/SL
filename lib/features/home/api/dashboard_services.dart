import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../core/model/response_model.dart';
import '../../../core/network/base_api_service.dart';
import '../../../model/home_banner_model.dart';
import '../../../model/user_model.dart';
import '../../../shared/constant/enums.dart';
import '../../../shared/services/storage_service.dart';

class DashboardEndpoint {
  static const String user = '/users';
  static const String homeScreenBanner = '/api/banners';
  static const String coupon = '/api/qrcode/redeem';
}

class DashboardService extends BaseApiService {
  Rx<UserType> userType = UserType.guest.obs;
  String userId = "";

  Future<void> updateDeviceToken(String token) async {
    StorageService.instance.getUserId()?.id == null
        ? null
        : await post(
            '/sns/addEndpointForUser',
            data: {
              "token": token,
              "userId": StorageService.instance.getUserId()?.id,
            },
          );
  }

  Future<ResponseModel> getHomeScreenBanner() async {
    final res = await get(DashboardEndpoint.homeScreenBanner);
    ResponseModel resModel = ResponseModel<List<HomeBannerModel>>(
      message: res.data["message"],
      status: res.data["statusCode"] >= 200 && res.data["statusCode"] < 300,
      data: res.data["data"]
          .map<HomeBannerModel>((e) => HomeBannerModel.fromJson(e))
          .toList(),
    );
    return resModel.data != null
        ? ResponseModel<List<HomeBannerModel>>(
            message: resModel.message,
            status: resModel.status,
            data: resModel.data,
          )
        : ResponseModel<List<HomeBannerModel>>(
            message: resModel.message,
            status: resModel.status,
            data: [],
          );
  }

  Future<ResponseModel> getUserById(String id) async {
    var res = await get('${DashboardEndpoint.user}/$id');

    ResponseModel resModel = ResponseModel<UserModel>(
      message: res.data["message"],
      status: res.data["status"],
      data: UserModel.fromJson(res.data["data"]),
    );
    return resModel;
  }

  Future<ResponseModel> scanQRCode(String id) async {
    final res = await get('${DashboardEndpoint.coupon}/$id');
    ResponseModel resModel = ResponseModel(
      message: res.data["message"],
      status: res.data["status"],
      data: res.data["data"],
    );
    return resModel;
  }

  // purchase verification
  Future<ResponseModel> qrVerification({required String data}) async {
    var res = await post(
      DashboardEndpoint.coupon,
      data: {"qrCodeData": data, "userId": "68864b5c3bbf41257312a747"},
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer ${StorageService.instance.getToken()}",
        },
      ),
    );

    ResponseModel resModel = ResponseModel(
      message: res.data["message"],
      status: res.data["status"],
    );
    return resModel;
  }
}
