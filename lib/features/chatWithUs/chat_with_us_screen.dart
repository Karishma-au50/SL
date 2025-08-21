import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sl/shared/typography.dart';
import '../../shared/services/storage_service.dart';
import 'controller/chat_controller.dart';

class ChatWithUsScreen extends StatefulWidget {
  const ChatWithUsScreen({super.key});

  @override
  _ChatWithUsScreenState createState() => _ChatWithUsScreenState();
}

class _ChatWithUsScreenState extends State<ChatWithUsScreen> {
  late ChatController controller;
  late ScrollController _scrollController;

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  String _formatTime(DateTime dateTime) {
    int hour = dateTime.hour;
    int minute = dateTime.minute;
    String period = hour >= 12 ? 'PM' : 'AM';

    if (hour > 12) {
      hour -= 12;
    } else if (hour == 0) {
      hour = 12;
    }

    String minuteStr = minute.toString().padLeft(2, '0');
    return '$hour:$minuteStr $period';
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Delete any existing controller first
    if (Get.isRegistered<ChatController>()) {
      Get.delete<ChatController>();
    }
    // Create a fresh controller instance
    controller = Get.put(ChatController());

    // Listen to chat history changes and scroll to bottom
    ever(controller.chatHistory, (_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // Clean up the controller when leaving the screen
    if (Get.isRegistered<ChatController>()) {
      Get.delete<ChatController>();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001519),
      appBar: AppBar(
        backgroundColor: const Color(0xFF001519),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Chat With Us',
          style: AppTypography.heading6(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.resetChat(),
          ),
        ],
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Date Chip
              SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFFFF3F2),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: Text(
                  "${DateTime.now().day} ${_getMonthName(DateTime.now().month)}, ${DateTime.now().year}",
                  style: AppTypography.labelMedium(),
                ),
              ),
              const SizedBox(height: 10),

              // Chat Messages
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 0,
                  ),
                  itemCount: controller.chatHistory.length,
                  itemBuilder: (context, index) {
                    final item = controller.chatHistory[index];

                    // Bot Question
                    if (item.containsKey("question")) {
                      return Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Color(0xFFFFF7D9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // if first question, show "Bot" label
                                  if (index == 0) ...{
                                    Text(
                                      "Good Afternoon, ${StorageService.instance.getUserId()?.firstname}!",
                                      style: AppTypography.bodyMedium(),
                                    ),
                                    const SizedBox(height: 10),
                                  },
                                  Text(
                                    item["question"],
                                    style: AppTypography.bodyMedium(),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF3f3f3),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      children: (item["answers"] as List)
                                          .map<Widget>(
                                            (ans) => Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () => controller
                                                      .selectAnswer(ans),
                                                  child: Container(
                                                    padding: EdgeInsets.all(12),
                                                    color: Colors.white,
                                                    width: double.infinity,
                                                    child: Text(
                                                      ans["text"],
                                                      style:
                                                          AppTypography.bodyMedium(
                                                            color: Colors.black,
                                                          ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                // anser is last item then no divider
                                                if (ans !=
                                                    (item["answers"] as List)
                                                        .last) ...{
                                                  Divider(
                                                    height: 1,
                                                    color: Colors.grey.shade200,
                                                  ),
                                                },
                                              ],
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // QUESTION TIMESTAMP
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8, top: 2),
                              child: Text(
                                item["timestamp"] != null
                                    ? _formatTime(
                                        DateTime.parse(item["timestamp"]),
                                      )
                                    : _formatTime(DateTime.now()),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    // User Selected Answer
                    else if (item.containsKey("answer")) {
                      return Column(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Question Reference (Reply-to)
                                if (item["questionReference"] != null) ...{
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,

                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFFE5D2).withAlpha(150),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "SL Chemicals",
                                          style: AppTypography.heading6(),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          item["questionReference"],
                                          style: AppTypography.bodyMedium(),
                                        ),
                                      ],
                                    ),
                                  ),
                                },
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ).copyWith(top: 0),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFE5D2),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    item["answer"],
                                    style: AppTypography.bodyMedium(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // USER ANSWER TIMESTAMP
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8, top: 2),
                              child: Text(
                                item["timestamp"] != null
                                    ? _formatTime(
                                        DateTime.parse(item["timestamp"]),
                                      )
                                    : _formatTime(DateTime.now()),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    // End Message
                    else if (item.containsKey("end")) {
                      return Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            item["end"],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
