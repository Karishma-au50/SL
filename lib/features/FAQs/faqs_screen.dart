import 'dart:convert';
import 'package:flutter/material.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  late List<dynamic> faqData;
  List<bool> isExpanded = [];

  @override
  void initState() {
    super.initState();
    loadDummyData();
  }

  void loadDummyData() {
    String dummyJson = '''
    [
      {
        "question": "How to scan the QR stickers? How to start earning plus point reward points?",
        "answer": "To scan the QR stickers, open the app, tap on 'Scan QR', and point your camera to the sticker. Your points will be credited instantly."
      },
      {
        "question": "How to redeem my reward points?",
        "answer": "You can redeem your reward points by visiting the 'Rewards' section in the app and selecting your desired offer."
      },
      {
        "question": "What should I do if the QR code is not scanning?",
        "answer": "Ensure your camera lens is clean and the QR code is not damaged. Try scanning under good lighting conditions."
      }
    ]
    ''';

    faqData = json.decode(dummyJson);
    isExpanded = List.filled(faqData.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001519),
      appBar: AppBar(
        backgroundColor: const Color(0xFF001519),
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          "FAQ's",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: faqData.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  setState(() {
                    isExpanded[index] = !isExpanded[index];
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              faqData[index]["question"],
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              isExpanded[index] ? Icons.remove_circle_outline : Icons.add_circle_outline,
                              color: Colors.black54,
                            ),
                            onPressed: () {
                              setState(() {
                                isExpanded[index] = !isExpanded[index];
                              });
                            },
                          ),
                        ],
                      ),
                      if (isExpanded[index])
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            faqData[index]["answer"],
                            style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
