import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../model/chat_model.dart';
import '../../../widgets/toast/my_toast.dart';
import '../api/chat_service.dart';

class ChatController extends GetxController {
  final _api = ChatService();

  RxList<ChatModel> chatFlow = <ChatModel>[].obs;
  RxBool isLoading = false.obs;
  Rx<String?> currentId = Rx<String?>("1");
  RxList<Map<String, dynamic>> chatHistory = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadChats();
  }

  @override
  void onClose() {
    // Clean up when controller is disposed
    chatHistory.clear();
    currentId.value = null;
    super.onClose();
  }

  void resetChatOnEntry() {
    chatHistory.clear();
    if (chatFlow.isNotEmpty) {
      currentId.value = chatFlow.first.id;
      _showQuestion(chatFlow.first.id);
    }
  }

  Future<void> loadChats() async {
    try {
      isLoading.value = true;
      final res = await _api.getChats();
      if (res.status ?? false) {
        chatFlow.value = res.data?.chats ?? [];
        if (chatFlow.isNotEmpty) {
          _showQuestion(chatFlow.first.id);
        }
      } else {
        MyToasts.toastError(res.message ?? "Failed to load chats");
      }
    } on DioException catch (e) {
      MyToasts.toastError(e.response?.data["message"] ?? "Network error");
    } catch (e) {
      MyToasts.toastError("An unexpected error occurred");
    } finally {
      isLoading.value = false;
    }
  }

  void _showQuestion(String id) {
    final questionObj = chatFlow.firstWhereOrNull((q) => q.id == id);
    if (questionObj != null) {
      chatHistory.add({
        "_id": questionObj.id,
        "question": questionObj.question,
        "answers": questionObj.answers.map((a) => {
          "text": a.label,
          "nextId": a.nextId,
        }).toList(),
      });
      currentId.value = id;
    }
  }

  void selectAnswer(Map<String, dynamic> answer) {
    chatHistory.add({"answer": answer["text"]});

    if (answer["nextId"] != null && answer["nextId"].isNotEmpty) {
      final nextChat = chatFlow.firstWhereOrNull((chat) => chat.id == answer["nextId"]);
      if (nextChat != null) {
        if (nextChat.question != null && nextChat.question!.isNotEmpty) {
          // It's a question
          _showQuestion(answer["nextId"]);
        } else if (nextChat.answer != null && nextChat.answer!.isNotEmpty) {
          // It's an answer/end message
          chatHistory.add({
            "_id": nextChat.id,
            "question": nextChat.answer,
            "answers": <Map<String, String>>[], // Empty answers for final response
          });
          currentId.value = null;
        }
      }
    } else {
      chatHistory.add({"end": "Thank you for chatting with us!"});
      currentId.value = null;
    }
  }

  void resetChat() {
    chatHistory.clear();
    if (chatFlow.isNotEmpty) {
      currentId.value = chatFlow.first.id;
      _showQuestion(chatFlow.first.id);
    }
  }
}
