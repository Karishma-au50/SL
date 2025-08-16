import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../core/expections/custom_exception.dart';
import '../../../model/home_banner_model.dart';
import '../../../model/user_model.dart';
import '../../../model/wallet_history_model.dart';
import '../../../model/slc_video_model.dart';
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
      // Return static/dummy video URLs instead of API call
      await Future.delayed(
        Duration(milliseconds: 500),
      ); // Simulate network delay

      return [
        SLCVideoModel(
          url: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
          description: 'Sample YouTube Video 1',
        ),
        SLCVideoModel(
          url: 'https://www.youtube.com/watch?v=9bZkp7q19f0',
          description: 'Sample YouTube Video 2',
        ),
        SLCVideoModel(
          url: 'https://www.youtube.com/watch?v=ScMzIvxBSi4',
          description: 'Sample YouTube Video 3',
        ),
        SLCVideoModel(
          url: 'https://www.youtube.com/watch?v=fJ9rUzIMcZQ',
          description: 'Sample YouTube Video 4',
        ),
        // Add more sample videos as needed other then YouTube
        SLCVideoModel(
          url:
              'https://videos.pexels.com/video-files/8859849/8859849-uhd_1440_2560_25fps.mp4',
          description: 'Sample Network Video 1',
        ),
      ];
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
}
