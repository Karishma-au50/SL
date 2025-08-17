import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/faq_model.dart';
import '../home/controller/dashboard_controller.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final DashboardController _controller = Get.find<DashboardController>();
  List<FaqModel> faqData = [];
  List<bool> isExpanded = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadFAQs();
  }

  Future<void> _loadFAQs() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final faqs = await _controller.getFAQs();
      if (faqs != null) {
        setState(() {
          faqData = faqs;
          isExpanded = List.filled(faqData.length, false);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load FAQs';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading FAQs: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  Future<void> _refreshFAQs() async {
    await _loadFAQs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001519),
      appBar: AppBar(
        backgroundColor: const Color(0xFF001519),
        elevation: 0,
        // leading: const BackButton(color: Colors.white),
        title: const Text(
          "FAQ's",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshFAQs,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        ),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              errorMessage!,
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _refreshFAQs,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (faqData.isEmpty) {
      return const Center(
        child: Text(
          'No FAQs available',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshFAQs,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: faqData.length,
        itemBuilder: (context, index) {
          final faq = faqData[index];
          return Container(
            margin: const EdgeInsets.only(top: 10),
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
                            faq.question,
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
                          faq.answer,
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
    );
  }
}
