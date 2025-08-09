import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:sl/routes/app_routes.dart';

import '../../../model/user_model.dart';
import '../../../shared/services/storage_service.dart';
import '../../../widgets/toast/my_toast.dart';
import '../../home/controller/dashboard_controller.dart';
import '../api/auth_service.dart';

class AuthController extends GetxController {
  final _api = AuthService();

  // register
  Future<bool> register(UserModel user) async {
    try {
      final res = await _api.register(user);
      if (!(res.status ?? true)) {
        return true;
      } else {
        // MyToasts.toastError(res.message ?? "Error");
      }
    } on DioException catch (e) {
      MyToasts.toastError(e.response?.data["message"] ?? "Error");
    } on Exception catch (e) {
      MyToasts.toastError(e.toString());
    }
    return false;
  }

  // send OTP
  Future<dynamic> sendOTP(String mobile) async {
    try {
      final res = await _api.sendOTP(mobile);
      if (!(res.status ?? true)) {
        return res.data;
      } else {
        MyToasts.toastError(res.message ?? "Error");
        return null;
      }
    } catch (e) {
      MyToasts.toastError(e.toString());
    }
  }

  Future<bool?> verifyOtp(String mobile, String otp) async {
    try {
      final res = await _api.verifyOtp(mobile, otp);
      if (!(res.status ?? true)) {
        bool isUserExist = res.data["isUserExist"] ?? false;
        if (isUserExist) {
          StorageService.instance.setToken(res.data['token']);
        }
        return isUserExist;
      } else {
        MyToasts.toastError(res.message ?? "Error");
        return null;
      }
    } on DioException catch (e) {
      MyToasts.toastError(e.response?.data["message"] ?? "Error");
      return null;
    } catch (e) {
      MyToasts.toastError(e.toString());
      return null;
    }
  }

}
