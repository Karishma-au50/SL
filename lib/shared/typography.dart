import 'package:flutter/material.dart';

/// Typography class for managing consistent text styles across the app
class AppTypography {
  // Font Family Constants
  static const String ttFirsNeue = 'TT Firs Neue Trial';
  static const String ttFirsNeueVar = 'TT Firs Neue Trial Var';
  static const String defaultFont = 'System'; // Will use system default

  // Base text styles with TT Firs Neue font
  static const TextStyle _baseStyle = TextStyle(
    fontFamily: ttFirsNeueVar,
    height: 1.0,
    letterSpacing: 0.0,
  );

  // Heading Styles
  static TextStyle heading1({Color? color}) => _baseStyle.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: color,
  );

  static TextStyle heading2({Color? color}) => _baseStyle.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: color,
  );

  static TextStyle heading3({Color? color}) => _baseStyle.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: color,
  );

  static TextStyle heading4({Color? color}) => _baseStyle.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: color,
  );

  static TextStyle heading5({Color? color}) => _baseStyle.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: color,
  );

  static TextStyle heading6({Color? color}) => _baseStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: color,
  );

  // Body Text Styles
  static TextStyle bodyLarge({Color? color}) => _baseStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: color,
  );

  static TextStyle bodyMedium({Color? color}) => _baseStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: color,
  );
    static TextStyle bodyBold({Color? color}) => _baseStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: color,
  );

  static TextStyle bodySmall({Color? color}) => _baseStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: color,
  );

  // Label Styles
  static TextStyle labelLarge({Color? color}) => _baseStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: color,
  );

  static TextStyle labelMedium({Color? color}) => _baseStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: color,
  );

  static TextStyle labelSmall({Color? color}) => _baseStyle.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: color,
  );

  // Special Typography (matching your requirements)
  static TextStyle ttFirsNeueTitle({Color? color}) => _baseStyle.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.0, // 100% line height
    letterSpacing: 0.0, // 0% letter spacing
    color: color,
  );

  // Button Text Styles
  static TextStyle buttonLarge({Color? color}) => _baseStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: color,
  );

  static TextStyle buttonMedium({Color? color}) => _baseStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: color,
  );

  static TextStyle buttonSmall({Color? color}) => _baseStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: color,
  );

  // Caption and Overline
  static TextStyle caption({Color? color}) => _baseStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: color,
  );

  static TextStyle overline({Color? color}) => _baseStyle.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
    color: color,
  );

  // Utility methods
  static TextStyle withCustomFont({
    required String fontFamily,
    required double fontSize,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
    double height = 1.0,
    double letterSpacing = 0.0,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  // Method to apply consistent theming to any TextStyle
  static TextStyle applyTheme(
    TextStyle baseStyle, {
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    String? fontFamily,
  }) {
    return baseStyle.copyWith(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
    );
  }

  // Responsive typography helper
  static double getResponsiveFontSize(
    BuildContext context,
    double baseFontSize,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 375) {
      return baseFontSize * 0.9;
    } else if (screenWidth > 414) {
      return baseFontSize * 1.1;
    }

    return baseFontSize;
  }

  // Create responsive text style
  static TextStyle responsive(
    BuildContext context, {
    required double fontSize,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
    String? fontFamily,
  }) {
    final responsiveFontSize = getResponsiveFontSize(context, fontSize);

    return TextStyle(
      fontSize: responsiveFontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: fontFamily ?? ttFirsNeue,
    );
  }
}
