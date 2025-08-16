import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';

import '../home/controller/dashboard_controller.dart';

class CompanyPolicyScreen extends StatefulWidget {
  CompanyPolicyScreen({super.key});

  @override
  State<CompanyPolicyScreen> createState() => _CompanyPolicyScreenState();
}

class _CompanyPolicyScreenState extends State<CompanyPolicyScreen> {
  List<Map<String, dynamic>> dummyJson = [];

  @override
  void initState() {
    super.initState();
    // You can load the dummyJson from a local file or API if needed

    // For now, we are using the hardcoded dummyJson above
    // You can replace this with your API call or local file loading logic
    loadDummyData();
  }

  void loadDummyData() {
    DashboardController controller = Get.find();
    controller.getCompanyPolicyDetails().then((data) {
      setState(() {
        dummyJson = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (dummyJson.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF001519),
          elevation: 0,
          title: const Text(
            'Company Policy',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          leading: const BackButton(color: Colors.white),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    List<PolicySection> policies = dummyJson
        .map((e) => PolicySection.fromJson(e))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF001519),
      appBar: AppBar(
        backgroundColor: const Color(0xFF001519),
        elevation: 0,
        title: const Text(
          'Company Policy',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: policies
                      .map(
                        (policy) => _buildPolicySection(
                          title: policy.title,
                          date: policy.updatedAt,
                          content: policy.content,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicySection({
    required String title,
    required String date,
    required List<String> content,
  }) {
    // Split title on real newline
    final titleLines = title.split('\n');
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...titleLines.map(
            (line) => Text(
              line,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Updated at $date",
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          ...content.map(
            (paragraph) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Html(data: paragraph),
            ),
          ),
        ],
      ),
    );
  }
}

class PolicySection {
  final String title;
  final String updatedAt;
  final List<String> content;

  PolicySection({
    required this.title,
    required this.updatedAt,
    required this.content,
  });

  factory PolicySection.fromJson(Map<String, dynamic> json) {
    return PolicySection(
      title: json['title'],
      updatedAt: json['updatedAt'],
      content: List<String>.from(json['content']),
    );
  }
}
