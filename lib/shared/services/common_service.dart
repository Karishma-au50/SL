import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:sl/model/user_detail_model.dart';

import '../../core/model/response_model.dart';
import '../../core/network/base_api_service.dart';
import '../../features/auth/api/auth_service.dart';
import 'storage_service.dart';

class CommonService extends BaseApiService {
  static CommonService get to => Get.find();

  Future<CommonService> init() async => this;

  Future<Response> getImage(String url) {
    return get(url, options: Options(responseType: ResponseType.bytes));
  }

  Future<UserDetailModel> getUserDetails({bool forceRefresh = false}) async {
    if (forceRefresh ||
        StorageService.instance.getString("user_detail") == null) {
      try {
        final userId = StorageService.instance.getUserId()?.id;
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

        if (resModel.status ?? false) {
          StorageService.instance.setString(
            "user_detail",
            json.encode(resModel.data.toJson()),
          );
        }

        return resModel.data;
      } catch (e) {
        return UserDetailModel.fromJson(
          json.decode(StorageService.instance.getString("user_detail") ?? '{}'),
        );
      }
    } else {
      final cachedData = StorageService.instance.getString("user_detail");
      if (cachedData != null) {
        return UserDetailModel.fromJson(json.decode(cachedData));
      } else {
        throw Exception('No cached user details found');
      }
    }
  }
}
