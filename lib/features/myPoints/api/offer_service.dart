import '../../../core/model/response_model.dart';
import '../../../core/network/base_api_service.dart';
import '../../../model/offer_model.dart';
import '../../../model/withdrawal_model.dart';

class OfferEndpoint {
  static const getOffers = '/api/offers';
  static const offers = '/api/offers'; // Old endpoint, kept for reference
  static const submitWithdrawal = '/api/rewardClaims/submit';
}
class OfferService extends BaseApiService {
  Future<ResponseModel> getAllOffers() async {
    final res = await get(OfferEndpoint.getOffers);
    ResponseModel resModel = ResponseModel<List<OfferModel>>(
      message: res.data["message"],
       status: res.data["statusCode"] >= 200 && res.data["statusCode"] < 300,
      data: res.data["data"]["offers"]
          .map<OfferModel>((e) => OfferModel.fromJson(e))
          .toList(),
    );
    return resModel.data != null
        ? ResponseModel<List<OfferModel>>(
            message: resModel.message,
            status: resModel.status,
            data: resModel.data,
          )
        : ResponseModel<List<OfferModel>>(
            message: resModel.message,
            status: resModel.status,
            data: [],
          );
  }

  Future<ResponseModel> getOfferById(
    String offerId) async {
    final res = await get(
       '${OfferEndpoint.offers}/$offerId');
    ResponseModel resModel = ResponseModel<OfferModel>(
      message: res.data["message"],
      status: res.data["status"],
      data: OfferModel.fromJson(res.data["data"]["offer"]),
    );
    return  resModel.data != null
        ? ResponseModel<OfferModel>(
            message: resModel.message,
            status: resModel.status,
            data: resModel.data,
          )
        : ResponseModel<OfferModel>(
            message: resModel.message,
            status: resModel.status,
            data: null,
          );

  }

  Future<ResponseModel> submitWithdrawal(WithdrawalRequest withdrawalRequest) async {
    final res = await post(
      OfferEndpoint.submitWithdrawal,
      data: withdrawalRequest.toJson(),
    );
    
    ResponseModel resModel = ResponseModel<WithdrawalResponse>(
      message: res.data["message"] ?? "Withdrawal request submitted successfully",
      status: res.data["statusCode"] >= 200 && res.data["statusCode"] < 300,
      data: WithdrawalResponse.fromJson(res.data),
    );
    
    return resModel;
  }

 
}
