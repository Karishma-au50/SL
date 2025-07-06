import 'package:get/get.dart';

import '../../../model/user_model.dart';
import '../../../shared/services/storage_service.dart';
import '../../../widgets/toast/my_toast.dart';
import '../../home/controller/dashboard_controller.dart';
import '../api/auth_service.dart';

class AuthController extends GetxController {
  final _api = AuthService();

  // Future<void> login({required String mobile,}) async {
  //   try {
  //     final res = await _api.login(mobile: mobile);
  //     if (res.status ?? false) {
  //       MyToasts.toastSuccess(res.message ?? "Success");
  //     }
  //     // NavHelper.offAllToNamed(AppRoutes.home);
  //   } catch (e) {
  //     MyToasts.toastError(e.toString());
  //   }
  // }

 
  // register
  Future<bool> register(UserModel user) async {
    try {
      final res = await _api.register(user);
      if (res.status ?? false) {
        return true;
      } else {
        // MyToasts.toastError(res.message ?? "Error");
      }
    } catch (e) {
      MyToasts.toastError(e.toString());
    }
    return false;
  }

  // send OTP
  Future<void> sendOTP(String mobile) async {
    try {
      final res = await _api.sendOTP(mobile);
      if (res.status ?? false) {
        MyToasts.toastSuccess(res.message ?? "Success");
        return res.data;
      }
    } catch (e) {
      MyToasts.toastError(e.toString());
    }
  }

Future<void> verifyOtp(String mobile, String otp) async {
    try {
      final res = await _api.verifyOtp(mobile, otp);
      if (res.status ?? false) {
        MyToasts.toastSuccess(res.message ?? "Success");
        return res.data;
     
      } else {
        MyToasts.toastError(res.message ?? "Error");
      }
    } catch (e) {
      MyToasts.toastError(e.toString());
    }
  }
  // forgot password
  // Future<List<UserModel>?> forgotPass(String mobile, String password) async {
  //   try {
  //     final res = await _api.forgotPass(mobile, password);
  //     if (res.status ?? false) {
  //       return res.data;
  //     }
  //   } catch (e) {
  //     MyToasts.toastError(e.toString());
  //     return null;
  //   }
  //   return null;
  // }
}
