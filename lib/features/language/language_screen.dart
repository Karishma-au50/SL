import 'package:flutter/material.dart';

class LanguageSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB10606), // Dark red top background
      body: Column(
        children: [
          const SizedBox(height: 60),
          // Logo Section
          Center(
            child: Text(
              "SL",
              style: TextStyle(
                color: Colors.white,
                fontSize: 60,
                fontWeight: FontWeight.bold,
                fontFamily: 'Serif',
              ),
            ),
          ),
          const SizedBox(height: 20),

          // White rounded container
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Choose Your Language",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Choose the type of your account language, be\ncareful to Continue As A........",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Language Options
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LanguageCard(
                        iconPath: Icons.translate,
                        label: "English",
                        onTap: () {
                          // handle English selection
                        },
                      ),
                      const SizedBox(width: 20),
                      LanguageCard(
                        iconPath: Icons.translate,
                        label: "हिंदी",
                        onTap: () {
                          // handle Hindi selection
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LanguageCard extends StatelessWidget {
  final IconData iconPath;
  final String label;
  final VoidCallback onTap;

  const LanguageCard({
    required this.iconPath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: 130,
          height: 150,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.red.shade100,
                radius: 30,
                child: Icon(
                  iconPath,
                  size: 30,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
