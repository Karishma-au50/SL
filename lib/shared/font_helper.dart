import 'package:flutter/material.dart';

class FontHelper {
  //Font Size 9
  static TextStyle ts08w400({Color? color}) {
    return TextStyle(fontSize: 8, fontWeight: FontWeight.w400, color: color);
  }

  // Font Size 10
  static TextStyle ts10w400({Color? color}) {
    return TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: color);
  }

  static TextStyle ts10w500({Color? color}) {
    return TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: color);
  }

  static TextStyle ts10w600({Color? color}) {
    return TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color);
  }

  static TextStyle ts10w700({Color? color}) {
    return TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color);
  }

  // Font Size 12

  static TextStyle ts12w400({Color? color}) {
    return TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: color);
  }

  static TextStyle ts12w500({Color? color}) {
    return TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: color);
  }

  static TextStyle ts12w600({Color? color}) {
    return TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color);
  }

  static TextStyle ts12w700({Color? color}) {
    return TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color);
  }

  // Font Size 14

  static TextStyle ts14w400({Color? color}) {
    return TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: color);
  }

  static TextStyle ts14w500({Color? color}) {
    return TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: color);
  }

  static TextStyle ts14w600({Color? color}) {
    return TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: color);
  }

  static TextStyle ts14w700({Color? color}) {
    return TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: color);
  }

  // Font Size 16

  static TextStyle ts16w400({Color? color}) {
    return TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: color);
  }

  static TextStyle ts16w500({Color? color}) {
    return TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: color);
  }

  static TextStyle ts16w600({Color? color}) {
    return TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color);
  }

  static TextStyle ts16w700({Color? color}) {
    return TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color);
  }

  // Font Size 18

  static TextStyle ts18w400({Color? color}) {
    return TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: color);
  }

  static TextStyle ts18w500({Color? color}) {
    return TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: color);
  }

  static TextStyle ts18w600({Color? color}) {
    return TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: color);
  }

  static TextStyle ts18w700({Color? color}) {
    return TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color);
  }

  // Font Size 20

  static TextStyle ts20w400({Color? color}) {
    return TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: color);
  }

  static TextStyle ts20w500({Color? color}) {
    return TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: color);
  }

  static TextStyle ts20w600({Color? color}) {
    return TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: color);
  }

  static TextStyle ts20w700({Color? color}) {
    return TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: color);
  }

  static TextStyle ts22w700({Color? color}) {
    return TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: color);
  }

  static TextStyle ts26w700({Color? color}) {
    return TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: color);
  }

  static TextStyle ts40w700({Color? color}) {
    return TextStyle(fontSize: 40, fontWeight: FontWeight.w700, color: color);
  }

  static TextStyle ts50w600({Color? color}) {
    return TextStyle(fontSize: 55, fontWeight: FontWeight.w600, color: color);
  }

  // Custom TT Firs Neue Trial Typography
  static TextStyle ttFirsNeueTitle({Color? color}) {
    return TextStyle(
      fontFamily: 'TT Firs Neue Trial',
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 1.0, // line-height: 100%
      letterSpacing: 0.0, // letter-spacing: 0%
      color: color,
    );
  }

  // Generic typography helper for custom font families
  static TextStyle customTypography({
    String? fontFamily,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
    double height = 1.0,
    double letterSpacing = 0.0,
    Color? color,
    TextAlign textAlign = TextAlign.start,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
      color: color,
    );
  }

  // Generic helper to create TextStyle with consistent theming
  static TextStyle createTextStyle({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
    String? fontFamily,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
    Color? decorationColor,
    FontStyle? fontStyle,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: fontFamily,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
      decorationColor: decorationColor,
      fontStyle: fontStyle,
    );
  }

  // Helper to apply TT Firs Neue font family to any existing TextStyle
  static TextStyle withTTFirsNeue(TextStyle baseStyle) {
    return baseStyle.copyWith(fontFamily: 'TT Firs Neue Trial Var Roman');
  }

  // Helper to create responsive text styles based on screen size
  static TextStyle responsiveTextStyle(
    BuildContext context, {
    required double fontSize,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
    String? fontFamily,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    double responsiveFontSize = fontSize;

    if (screenWidth < 375) {
      responsiveFontSize = fontSize * 0.9;
    } else if (screenWidth > 414) {
      responsiveFontSize = fontSize * 1.1;
    }

    return TextStyle(
      fontSize: responsiveFontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: fontFamily,
    );
  }
}
