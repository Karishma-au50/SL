import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/chat_controller.dart';

class ChatWithUsScreen extends StatefulWidget {
  const ChatWithUsScreen({super.key});

  @override
  _ChatWithUsScreenState createState() => _ChatWithUsScreenState();
}

class _ChatWithUsScreenState extends State<ChatWithUsScreen> {
  late ChatController controller;

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  @override
  void initState() {
    super.initState();
    // Delete any existing controller first
    if (Get.isRegistered<ChatController>()) {
      Get.delete<ChatController>();
    }
    // Create a fresh controller instance
    controller = Get.put(ChatController());
  }

  @override
  void dispose() {
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
        title: const Text(
          'Redeem My Plus Points',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
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
          return const Center(
            child: CircularProgressIndicator(),
          );
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Chip(
                  label: Text(
                    "${DateTime.now().day} ${_getMonthName(DateTime.now().month)}, ${DateTime.now().year}",
                    style: const TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                  backgroundColor: Colors.grey.shade100,
                ),
              ),
          
              // Chat Messages
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical:0),
                  itemCount: controller.chatHistory.length,
                  itemBuilder: (context, index) {
                    final item = controller.chatHistory[index];
          
                    // Bot Question
                    if (item.containsKey("question")) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          // width: MediaQuery.of(context).size.width * 0.8,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("SL Chemicals",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange.shade800)),
                              const SizedBox(height: 6),
                              Text(item["question"],
                                  style: const TextStyle(fontSize: 14)),
                              const SizedBox(height: 8),
                              ...(item["answers"] as List)
                                  .map<Widget>(
                                    (ans) => GestureDetector(
                                      onTap: () => controller.selectAnswer(ans),
                                      child: Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                              color: Colors.grey.shade300),
                                        ),
                                        child: Text(
                                          ans["text"],
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ],
                          ),
                        ),
                      );
                    }
          
                    // User Selected Answer
                    else if (item.containsKey("answer")) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.yellow.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("You",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.brown.shade700)),
                              const SizedBox(height: 4),
                              Text(item["answer"],
                                  style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
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
                          child: Text(item["end"],
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
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
