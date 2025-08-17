import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../core/model/response_model.dart';
import '../../../core/network/base_api_service.dart';
import '../../../model/user_detail_model.dart';
import '../../../model/user_model.dart';
import '../../../model/user_redeem_history_model.dart';
import '../../../shared/services/storage_service.dart';

class AuthEndpoint {
  static const sendOTP = '/api/users/send-otp';
  static const register = '/api/users';
  static const verifyOtp = '/api/users/verify-otp';
  static const getUserDetails = '/api/users';
  static const getRedemptionPointsSummary = '/api/redemptions/user';
}

class AuthService extends BaseApiService {
  // register

  Future<ResponseModel> register(UserModel user) async {
    final res = await post(AuthEndpoint.register, data: user.toFormData());

    ResponseModel resModel = ResponseModel(
      message: res.data["message"],
      status: res.data["error"],
      data: res.data['data'],
    );
    return resModel;
  }

  // SEND OTP
  Future<ResponseModel> sendOTP(String mobile) async {
    final res = await post(AuthEndpoint.sendOTP, data: {"mobile": mobile});
    ResponseModel resModel = ResponseModel(
      message: res.data["message"],
      status: res.data["error"] ?? true,
      data: res.data['data'],
    );
    return resModel;
  }

  Future<ResponseModel> verifyOtp(String mobile, String otp) async {
    final res = await post(
      AuthEndpoint.verifyOtp,
      data: {"mobile": mobile, "otp": otp},
    );
    ResponseModel resModel = ResponseModel(
      message: res.data["message"],
      status: res.data["error"],
      data: res.data['data'],
    );
    if (!(resModel.status ?? true) && resModel.data['isUserExist'] == true) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(
        res.data["data"]['token'],
      );
      StorageService.instance.setUserId(UserModel.fromJson(decodedToken));
      StorageService.instance.setToken(res.data['data']['token']);
    }
    return resModel;
  }

  // Get user details
  Future<ResponseModel> getUserDetails(String userId) async {
    final res = await get(
      '${AuthEndpoint.getUserDetails}/$userId',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          "Authorization": StorageService.instance.getToken(),
        },
      ),
    );

    ResponseModel resModel = ResponseModel<UserDetailModel>(
      message: res.data["message"] ?? "User details fetched successfully",
      status: res.data["statusCode"] >= 200 && res.data["statusCode"] < 300,
      data: UserDetailModel.fromJson(res.data["data"]),
    );

    return resModel;
  }

  // get user redeem points history
  Future<ResponseModel> getRedemptionHistory(String userId) async {
    final res = await get(
      '${AuthEndpoint.getRedemptionPointsSummary}/$userId/points-summary',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          "Authorization": StorageService.instance.getToken(),
        },
      ),
    );

    ResponseModel resModel = ResponseModel<UserRedeemHistoryModel>(
      message: res.data["message"],
      status: res.data["statusCode"] >= 200 && res.data["statusCode"] < 300,
      data: UserRedeemHistoryModel.fromJson(res.data["data"]),
    );

    return resModel;
  }

  // forgot password
  // Future<ResponseModel> forgotPass(String mobile, String password) async {
  //   final res = await post(
  //     AuthEndpoint.sendOTP,
  //     data: {"mobile": mobile, "password": password},
  //   );
  //   ResponseModel resModel = ResponseModel<List<UserModel>>(
  //     message: res.data["message"],
  //     status: res.data["error"],
  //     data: res.data["data"]
  //         .map<UserModel>((e) => UserModel.fromJson(e))
  //         .toList(),
  //   );
  //   return resModel;
  // }
}
