

import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../core/model/response_model.dart';
import '../../../core/network/base_api_service.dart';
import '../../../model/user_model.dart';
import '../../../shared/services/storage_service.dart';

class AuthEndpoint {
  static const sendOTP = '/api/users/send-otp';
  static const register = '/api/users';
  static const verifyOtp = '/auth/verifyOtp';

}

class AuthService extends BaseApiService {
  // Future<ResponseModel> login(
  //     {required String mobile,}) async {
  //   final res = await post(
  //     AuthEndpoint.login,
  //     data: {'mobile': mobile},
  //   );
  //   // Map<String, dynamic> decodedToken = JwtDecoder.decode(res.data['data']);
  //   // print("Decoded json :- ${decodedToken}");
  //   // StorageService.instance.setUserId(UserModel.fromJson(decodedToken));
  //   // StorageService.instance.setToken(res.data['data']);
  //   return ResponseModel<String>.empty().fromJson(res.data);
  // }

  // register

  Future<ResponseModel> register(UserModel user) async {
  
    final res = await post(AuthEndpoint.register, data: user);

    ResponseModel resModel = ResponseModel<String>(
      message: res.data["message"],
      status: res.data["status"],
      data: res.data['data'],
    );
    if (resModel.status == true) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(resModel.data['token']);
      StorageService.instance.setUserId(UserModel.fromJson(decodedToken));
      StorageService.instance.setToken(resModel.data);
    }
    return resModel;
  }

  // SEND OTP
  Future<ResponseModel> sendOTP(String mobile) async {
    final res = await post(
      AuthEndpoint.sendOTP,
      data: {"mobile": mobile},
    );
    ResponseModel resModel = ResponseModel(
      message: res.data["message"],
      status: res.data["status"],
    );
    return resModel;
  }
  Future <ResponseModel> verifyOtp(String mobile, String otp) async {
    final res = await post(
      AuthEndpoint.verifyOtp,
      data: {"mobile": mobile, "otp": otp},
    );
    ResponseModel resModel = ResponseModel(
      message: res.data["message"],
      status: res.data["status"],
    );
    if (resModel.status == true) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(res.data['token']);
      StorageService.instance.setUserId(UserModel.fromJson(decodedToken));
      StorageService.instance.setToken(res.data['data']['token']);
    }
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
  //     status: res.data["status"],
  //     data: res.data["data"]
  //         .map<UserModel>((e) => UserModel.fromJson(e))
  //         .toList(),
  //   );
  //   return resModel;
  // }
}
