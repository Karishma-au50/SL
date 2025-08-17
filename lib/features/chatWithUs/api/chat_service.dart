import 'package:dio/dio.dart';

import '../../../core/model/response_model.dart';
import '../../../core/network/base_api_service.dart';
import '../../../model/chat_model.dart';
import '../../../shared/services/storage_service.dart';

class ChatEndpoint {
  static const String chat = '/api/chat/';
}

class ChatService extends BaseApiService {
  Future<ResponseModel<ChatResponseModel>> getChats() async {
    try {
      final res = await get(ChatEndpoint.chat,
         options: Options(
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer ${StorageService.instance.getToken()}",
        },
      ),
      );
      ResponseModel<ChatResponseModel> resModel = ResponseModel<ChatResponseModel>(
        message: res.data["message"],
        status: res.data["statusCode"] >= 200 && res.data["statusCode"] < 300,
        data: ChatResponseModel.fromJson(res.data["data"]),
      );
      return resModel;
    } on DioException catch (e) {
      return ResponseModel<ChatResponseModel>(
        message: e.response?.data["message"] ?? "Network error occurred",
        status: false,
        data: null,
      );
    } catch (e) {
      return ResponseModel<ChatResponseModel>(
        message: "An unexpected error occurred",
        status: false,
        data: null,
      );
    }
  }
}
