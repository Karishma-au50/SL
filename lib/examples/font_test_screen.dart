import 'package:flutter/material.dart';
import 'package:sl/shared/typography.dart';

/// Widget to test and showcase TT Firs Neue font family
class FontTestScreen extends StatelessWidget {
  const FontTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TT Firs Neue Font Test',
          style: AppTypography.heading6(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TT Firs Neue Trial Font Family',
              style: AppTypography.heading4(color: Colors.black87),
            ),
            const SizedBox(height: 20),

            // Test different font weights
            _buildFontWeightTest('Thin (100)', FontWeight.w100),
            _buildFontWeightTest('ExtraLight (200)', FontWeight.w200),
            _buildFontWeightTest('Light (300)', FontWeight.w300),
            _buildFontWeightTest('Regular (400)', FontWeight.w400),
            _buildFontWeightTest('Medium (500)', FontWeight.w500),
            _buildFontWeightTest('DemiBold (600)', FontWeight.w600),
            _buildFontWeightTest('Bold (700)', FontWeight.w700),
            _buildFontWeightTest('ExtraBold (800)', FontWeight.w800),
            _buildFontWeightTest('Black (900)', FontWeight.w900),

            const SizedBox(height: 30),

            Text(
              'TT Firs Neue Trial Var Font Family',
              style: AppTypography.heading4(color: Colors.black87),
            ),
            const SizedBox(height: 20),

            _buildVarFontTest('Variable Roman', FontWeight.w400, false),
            _buildVarFontTest('Variable Italic', FontWeight.w400, true),

            const SizedBox(height: 30),

            Text(
              'Your Custom Typography Styles',
              style: AppTypography.heading4(color: Colors.black87),
            ),
            const SizedBox(height: 20),

            Text(
              'Custom TT Firs Neue Title Style',
              style: AppTypography.ttFirsNeueTitle(color: Colors.blue),
            ),
            const SizedBox(height: 10),

            Text(
              'This is the exact style you requested: 20px, FontWeight 600, 100% line height, 0% letter spacing',
              style: AppTypography.bodyMedium(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFontWeightTest(String label, FontWeight weight) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'The quick brown fox jumps over the lazy dog',
            style: TextStyle(
              fontFamily: 'TT Firs Neue Trial',
              fontSize: 18,
              fontWeight: weight,
              color: Colors.black87,
            ),
          ),
          const Divider(height: 16),
        ],
      ),
    );
  }

  Widget _buildVarFontTest(String label, FontWeight weight, bool isItalic) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'The quick brown fox jumps over the lazy dog',
            style: TextStyle(
              fontFamily: 'TT Firs Neue Trial Var',
              fontSize: 18,
              fontWeight: weight,
              fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
              color: Colors.black87,
            ),
          ),
          const Divider(height: 16),
        ],
      ),
    );
  }
}
