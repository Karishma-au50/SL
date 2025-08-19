import 'package:flutter/material.dart';
import 'package:sl/shared/typography.dart';
import 'package:sl/shared/font_helper.dart';

/// Example widget demonstrating the usage of generic typography helpers
class TypographyExampleScreen extends StatelessWidget {
  const TypographyExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Typography Examples',
          style: AppTypography.heading5(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Using AppTypography class
            Text(
              'AppTypography Examples',
              style: AppTypography.heading4(color: Colors.black87),
            ),
            const SizedBox(height: 16),

            Text(
              'TT Firs Neue Title (Your Custom Style)',
              style: AppTypography.ttFirsNeueTitle(color: Colors.blue),
            ),
            const SizedBox(height: 8),

            Text(
              'Heading 1 - Large heading',
              style: AppTypography.heading1(color: Colors.black87),
            ),
            const SizedBox(height: 8),

            Text(
              'Heading 2 - Medium heading',
              style: AppTypography.heading2(color: Colors.black87),
            ),
            const SizedBox(height: 8),

            Text(
              'Body Large - Main content text',
              style: AppTypography.bodyLarge(color: Colors.black87),
            ),
            const SizedBox(height: 8),

            Text(
              'Body Medium - Secondary content',
              style: AppTypography.bodyMedium(color: Colors.black54),
            ),
            const SizedBox(height: 8),

            Text(
              'Label Large - Important labels',
              style: AppTypography.labelLarge(color: Colors.blue),
            ),
            const SizedBox(height: 16),

            // Using FontHelper class
            Text(
              'FontHelper Examples',
              style: FontHelper.ts18w600(color: Colors.black87),
            ),
            const SizedBox(height: 16),

            Text(
              'Custom Typography with specific font',
              style: FontHelper.customTypography(
                fontFamily: 'TT Firs Neue Trial Var Roman',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.green,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Responsive Text (will adapt to screen size)',
              style: FontHelper.responsiveTextStyle(
                context,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 16),

            // Using AppTypography with custom font
            Text(
              'Custom Font Example',
              style: AppTypography.withCustomFont(
                fontFamily: 'CustomFont',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.red,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 16),

            // Responsive typography
            Text(
              'Responsive Typography',
              style: AppTypography.responsive(
                context,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 16),

            // Button styles
            ElevatedButton(
              onPressed: () {},
              child: Text(
                'Button with Custom Typography',
                style: AppTypography.buttonLarge(color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),

            // Example of applying theme to existing style
            Text(
              'Modified Base Style',
              style: AppTypography.applyTheme(
                AppTypography.bodyLarge(),
                color: Colors.indigo,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
