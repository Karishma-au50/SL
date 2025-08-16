import 'package:flutter/material.dart';

class ChooseLanguageScreen extends StatelessWidget {
  const ChooseLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top red background with logo
          Stack(
            children: [
              // Background image
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.35,
                child: Image.asset(
                  "assets/images/bgImage.png", // your red background image
                  fit: BoxFit.cover,
                ),
              ),
              // Logo in center
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/Union.png", // your logo image
                    height: 120,
                  ),
                ),
              ),
            ],
          ),

          // White rounded container
          Expanded(
            child: Container(
             width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  const Text(
                    "Choose Your Language",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      "Choose the type of your account language.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Language cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLanguageCard(
                        context,
                        iconPath: "assets/images/eng.png",
                        label: "English",
                        onTap: () {
                          // Handle English selection
                        },
                      ),
                      const SizedBox(width: 16),
                      Column(
                        children: [
                          SizedBox(height: 26),
                          _buildLanguageCard(
                            context,
                            iconPath: "assets/images/hindi.png",
                            label: "हिंदी",
                            onTap: () {
                              // Handle Hindi selection
                            },
                          ),
                        ],
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

  Widget _buildLanguageCard(BuildContext context,
      {required String iconPath,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconPath, height: 90),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}
