import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../core/model/response_model.dart';
import '../../../core/network/base_api_service.dart';
import '../../../model/home_banner_model.dart';
import '../../../model/user_model.dart';
import '../../../model/wallet_history_model.dart';
import '../../../model/slc_video_model.dart';
import '../../../model/faq_model.dart';
import '../../../shared/constant/enums.dart';
import '../../../shared/services/storage_service.dart';

class DashboardEndpoint {
  static const String user = '/users';
  static const String homeScreenBanner = '/api/banners';
  static const String coupon = '/api/qrcode/redeem';
  static const String rewardClaimsHistory = '/api/rewardClaims/history';
  static const String slcVideos = '/api/faq/slc-videos';
  static const String faq = '/api/faq';
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
      status: res.data["statusCode"] >= 200 && res.data["statusCode"] < 300,
      data: UserModel.fromJson(res.data["data"]),
    );
    return resModel;
  }

  // purchase verification
  Future<ResponseModel> qrVerification({required String data}) async {
    var res = await post(
      DashboardEndpoint.coupon,
      data: {"qrCodeData": data, "userId": "${StorageService.instance.getUserId()?.id}"},
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer ${StorageService.instance.getToken()}",
        },
      ),
    );

    ResponseModel resModel = ResponseModel(
      message: res.data["message"],
      status: res.data["statusCode"] >= 200 && res.data["statusCode"] < 300,
      data: res.data["data"],
    );
    return resModel;
  }

  // get wallet history
  Future<ResponseModel> getWalletHistory() async {
    var res = await get(
      DashboardEndpoint.rewardClaimsHistory,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer ${StorageService.instance.getToken()}",
        },
      ),
    );

    ResponseModel resModel = ResponseModel<WalletHistoryModel>(
      message: res.data["message"],
      status: res.data["statusCode"] >= 200 && res.data["statusCode"] < 300,
      data: WalletHistoryModel.fromJson(res.data["data"]),
    );
    return resModel;
  }

  Future<ResponseModel> getSLCVideos() async {
    var res = await get(
      DashboardEndpoint.slcVideos,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer ${StorageService.instance.getToken()}",
        },
      ),
    );

    ResponseModel resModel = ResponseModel<List<SLCVideoModel>>(
      message: res.data["message"],
      status: res.data["statusCode"] >= 200 && res.data["statusCode"] < 300,
      data: (res.data["data"] as List<dynamic>)
          .map((item) => SLCVideoModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
    return resModel;
  }

  // fetch about us data
  Future<ResponseModel> getAboutUs() async {
    try {
      final res = await get(
        '/api/about/about',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer ${StorageService.instance.getToken()}",
          },
        ),
      );
      ResponseModel resModel = ResponseModel(
        message: res.data["message"],
        status: res.data["statusCode"] >= 200 && res.data["statusCode"] < 300,
        data: res.data["data"],
      );
      return resModel;
    } on DioException catch (e) {
      return ResponseModel.error(
        message: e.response?.data["message"] ?? "Error",
      );
    } catch (e) {
      return ResponseModel.error(message: e.toString());
    }
  }

  Future<ResponseModel<List<Map<String, dynamic>>>> getCompanyPolicy() async {
    try {
      final res = await get(
        '/api/about/company-policy',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer ${StorageService.instance.getToken()}",
          },
        ),
      );
      ResponseModel<List<Map<String, dynamic>>> resModel =
          ResponseModel<List<Map<String, dynamic>>>(
            message: res.data["message"],
            status:
                res.data["statusCode"] >= 200 && res.data["statusCode"] < 300,
            data: List<Map<String, dynamic>>.from(res.data["data"]),
          );
      return resModel;
    } on DioException catch (e) {
      return ResponseModel.error(
        message: e.response?.data["message"] ?? "Error",
      );
    } catch (e) {
      return ResponseModel.error(message: e.toString());
    }
  }

  Future<ResponseModel> getFAQs() async {
    var res = await get(DashboardEndpoint.faq,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer ${StorageService.instance.getToken()}",
        },
      ),
    );

    ResponseModel resModel = ResponseModel<List<FaqModel>>(
      message: res.data["message"],
      status: res.data["statusCode"] >= 200 && res.data["statusCode"] < 300,
      data: res.data["data"]
          .map<FaqModel>((e) => FaqModel.fromJson(e))
          .toList(),
    );
    return resModel;
  }
}
