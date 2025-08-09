import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:sl/features/myPoints/api/offer_service.dart';

import '../../../model/offer_model.dart';
import '../../../model/withdrawal_model.dart';
import '../../../widgets/toast/my_toast.dart';


class OfferController extends GetxController {
  final _api = OfferService();

  // register
  Future<List<OfferModel>?> getAllOffers() async {
    try {
      final res = await _api.getAllOffers();
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

  Future<OfferModel?> getOfferById(String offerId) async {
    try {
      final res = await _api.getOfferById(offerId);
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

  // Submit withdrawal request
  Future<bool> submitWithdrawal(WithdrawalRequest withdrawalRequest) async {
    try {
      final res = await _api.submitWithdrawal(withdrawalRequest);
      if (res.status ?? false) {
        MyToasts.toastSuccess(res.message ?? "Withdrawal request submitted successfully!");
        return true;
      } else {
        MyToasts.toastError(res.message ?? "Failed to submit withdrawal request");
        return false;
      }
    } on DioException catch (e) {
      MyToasts.toastError(e.response?.data["message"] ?? "Network error occurred");
      return false;
    } on Exception catch (e) {
      MyToasts.toastError(e.toString());
      return false;
    }
  }

  // redeem points
}
