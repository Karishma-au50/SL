import 'dart:convert';
import 'package:flutter/material.dart';

import '../../widgets/network_image_view.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  late Map<String, dynamic> aboutUsData;

  @override
  void initState() {
    super.initState();
    loadDummyData();
  }

  void loadDummyData() {
    String dummyJson = '''
    {
      "title": "About Us",
      "logoUrl": "https://i.pinimg.com/736x/5b/6b/bf/5b6bbf21c1f8b8c9fb4aa260273f5f16.jpg",
      "description": [
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s...",
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. It has survived not only five centuries, but also the leap into electronic typesetting...",
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry...",
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry..."
      ],
      "mapImageUrl": "https://i.pinimg.com/736x/5b/6b/bf/5b6bbf21c1f8b8c9fb4aa260273f5f16.jpg",
      "visitUs": "Stilt Floor A-327, Sector 136, Nagar, Noida, Uttar Pradesh, 201305",
      "email": "info@examicails.com",
      "phone": "+91 900-800-0000"
    }
    ''';

    aboutUsData = json.decode(dummyJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001519),
      appBar: AppBar(
        backgroundColor: const Color(0xFF001519),
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: Text(
          aboutUsData["title"],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
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
            children: [
              Center(
                child: Image.asset(
                  'assets/icons/logo.png',
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              ...aboutUsData["description"].map<Widget>(
                (text) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    text,
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              NetworkImageView(
                imgUrl: aboutUsData["mapImageUrl"],
                radius: 12,
                isFullPath: true,
              ),
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(12),
              //   child: Image.network(
              //     aboutUsData["mapImageUrl"],
              //     fit: BoxFit.cover,
              //   ),
              // ),
              const SizedBox(height: 16),
              _contactInfo(Icons.location_on, aboutUsData["visitUs"]),
              const SizedBox(height: 12),
              _contactInfo(Icons.email, aboutUsData["email"]),
              const SizedBox(height: 12),
              _contactInfo(Icons.phone, aboutUsData["phone"]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contactInfo(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF00BFA5)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: const TextStyle(fontSize: 14, height: 1.4)),
        ),
      ],
    );
  }
}
