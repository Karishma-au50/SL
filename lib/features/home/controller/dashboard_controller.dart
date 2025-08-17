import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:sl/shared/services/common_service.dart';

import '../../../core/expections/custom_exception.dart';
import '../../../model/home_banner_model.dart';
import '../../../model/user_model.dart';
import '../../../model/wallet_history_model.dart';
import '../../../model/slc_video_model.dart';
import '../../../model/faq_model.dart';
import '../../../shared/services/storage_service.dart';
import '../../../widgets/toast/my_toast.dart';
import '../api/dashboard_services.dart';

class DashboardController extends GetxController {
  final _api = DashboardService();
  Rx<UserModel?> userModel = StorageService.instance.getUserId().obs;

  void setUser(UserModel? user) {
    userModel.value = user;
    update();
    userModel.refresh();
  }

  //  get home screen baneer

  Future<List<HomeBannerModel>?> getHomeScreenBanner() async {
    try {
      final res = await _api.getHomeScreenBanner();
      if (res.status ?? true) {
        return res.data;
      } else {
        MyToasts.toastError(res.message ?? "Error");
      }
    } on DioException catch (e) {
      MyToasts.toastError(e.response?.data["message"] ?? "Error");
    } on Exception catch (e) {
      MyToasts.toastError(e.toString());
    }
    return null;
  }

  Future<UserModel?> fetchUser(String id) async {
    try {
      final res = await _api.getUserById(id);
      if (res.status ?? false) {
        return res.data!;
      } else {
        throw FetchDataException(res.message);
      }
    } catch (e) {
      MyToasts.toastError(e.toString());
      return null;
    }
  }

  // purchase verification
  Future<bool> qrVerification({required String data}) async {
    try {
      final res = await _api.qrVerification(data: data);
      if (res.status ?? false) {
      await  CommonService.to.getUserDetails(forceRefresh: true);
        // Show success toast with earned points

        MyToasts.toastSuccess(
          "QR code scanned successfully! You earned ${res.data?["pointsEarned"] ?? 0} points!",
        );
        return true;
      } else {
        // MyToasts.toastError(res.message ?? "Failed to verify QR code redemption");
        throw Exception(res.message ?? "Failed to verify QR code redemption");
        // return false;
      }
    } catch (e) {
      // MyToasts.toastError(e.toString());
      throw Exception("Error verifying QR code: ${e.toString()}");
      // return false;
    }
  }

  Future<WalletHistoryModel?> getWalletHistory() async {
    try {
      final res = await _api.getWalletHistory();
      if (res.status ?? false) {
        return res.data!;
      } else {
        throw FetchDataException(res.message);
      }
    } catch (e) {
      MyToasts.toastError(e.toString());
      return null;
    }
  }

  Future<List<SLCVideoModel>> getSLCVideos() async {
    try {
      final res = await _api.getSLCVideos();
      if (res.status ?? false) {
        return res.data??[];
      } else {
        throw FetchDataException(res.message);
      }
    }
    on DioException catch (e) {
      MyToasts.toastError(e.response?.data["message"] ?? "Error fetching videos");
      return [];
    } catch (e) {
      MyToasts.toastError(e.toString());
      return [];
    }
  }

  Future<Map<String, dynamic>> getAboutUsDetails() async {
    try {
      final res = await _api.getAboutUs();
      if (res.status ?? false) {
        return res.data!;
      } else {
        throw FetchDataException(res.message);
      }
    } catch (e) {
      MyToasts.toastError(e.toString());
      return {};
    }
  }

  Future<List<Map<String, dynamic>>> getCompanyPolicyDetails() async {
    try {
      final res = await _api.getCompanyPolicy();
      if (res.status ?? false) {
        return res.data!;
      } else {
        throw FetchDataException(res.message);
      }
    } catch (e) {
      MyToasts.toastError(e.toString());
      return [];
    }
  }

  Future<List<FaqModel>?> getFAQs() async {
    try {
      final res = await _api.getFAQs();
      if (res.status ?? false) {
        return res.data!;
      } else {
        throw FetchDataException(res.message);
      }
    } catch (e) {
      MyToasts.toastError(e.toString());
      return null;
    }
  }
}
