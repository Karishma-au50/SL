import 'dart:convert';
import 'package:flutter/material.dart';

class CompanyPolicyScreen extends StatelessWidget {
  const CompanyPolicyScreen({super.key});

  final String dummyJson = '''
  [
    {
      "title": "Terms and Conditions\\nPrivacy Policy",
      "updatedAt": "2025-07-31",
      "content": [
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s...",
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. It has survived not only five centuries..."
      ]
    },
    {
      "title": "Definitions and Key Terms",
      "updatedAt": "2025-07-31",
      "content": [
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry...",
        "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s..."

      ]
    },
    {
      "title": "User Rights",
      "updatedAt": "2025-07-31",
      "content": [
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry...",
        "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s..."
      ]
    },
  ]
  ''';

  @override
  Widget build(BuildContext context) {
    List<dynamic> jsonList = json.decode(dummyJson);
    List<PolicySection> policies =
        jsonList.map((e) => PolicySection.fromJson(e)).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF001519),
      appBar: AppBar(
        backgroundColor: const Color(0xFF001519),
        elevation: 0,
        title: const Text(
          'Company Policy',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
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
                      .map((policy) => _buildPolicySection(
                            title: policy.title,
                            date: policy.updatedAt,
                            content: policy.content,
                          ))
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text("Updated at $date", style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 12),
          ...content.map(
            (paragraph) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(paragraph, style: const TextStyle(fontSize: 14, height: 1.5)),
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
