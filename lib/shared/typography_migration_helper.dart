import 'package:flutter/material.dart';
import 'package:sl/shared/typography.dart';

/// Utility class to help migrate from static TextStyles to AppTypography
class TypographyMigrationHelper {
  /// Common TextStyle patterns and their AppTypography equivalents
  static const Map<String, String> _migrationMap = {
    // Common font sizes with weights
    'fontSize: 12, fontWeight: FontWeight.bold': 'AppTypography.labelSmall()',
    'fontSize: 12, fontWeight: FontWeight.w600': 'AppTypography.labelSmall()',
    'fontSize: 12, fontWeight: FontWeight.w500': 'AppTypography.labelSmall()',
    'fontSize: 12, fontWeight: FontWeight.w400': 'AppTypography.bodySmall()',
    'fontSize: 12': 'AppTypography.bodySmall()',

    'fontSize: 14, fontWeight: FontWeight.bold': 'AppTypography.labelMedium()',
    'fontSize: 14, fontWeight: FontWeight.w600': 'AppTypography.labelMedium()',
    'fontSize: 14, fontWeight: FontWeight.w500': 'AppTypography.labelMedium()',
    'fontSize: 14, fontWeight: FontWeight.w400': 'AppTypography.bodyMedium()',
    'fontSize: 14': 'AppTypography.bodyMedium()',

    'fontSize: 16, fontWeight: FontWeight.bold': 'AppTypography.labelLarge()',
    'fontSize: 16, fontWeight: FontWeight.w600': 'AppTypography.labelLarge()',
    'fontSize: 16, fontWeight: FontWeight.w500': 'AppTypography.labelLarge()',
    'fontSize: 16, fontWeight: FontWeight.w400': 'AppTypography.bodyLarge()',
    'fontSize: 16': 'AppTypography.bodyLarge()',

    'fontSize: 18, fontWeight: FontWeight.bold': 'AppTypography.heading5()',
    'fontSize: 18, fontWeight: FontWeight.w600': 'AppTypography.heading5()',
    'fontSize: 18': 'AppTypography.heading5()',

    'fontSize: 20, fontWeight: FontWeight.bold': 'AppTypography.heading4()',
    'fontSize: 20, fontWeight: FontWeight.w600': 'AppTypography.heading4()',
    'fontSize: 20': 'AppTypography.heading4()',

    'fontSize: 24, fontWeight: FontWeight.bold': 'AppTypography.heading3()',
    'fontSize: 24, fontWeight: FontWeight.w600': 'AppTypography.heading3()',
    'fontSize: 24': 'AppTypography.heading3()',

    // Common color patterns
    'color: Colors.grey': 'color: Colors.grey',
    'color: Colors.black87': 'color: Colors.black87',
    'color: Colors.black54': 'color: Colors.black54',
    'color: Colors.white': 'color: Colors.white',
  };

  /// Get AppTypography equivalent for common font sizes
  static TextStyle getTypographyForFontSize(
    double fontSize, {
    FontWeight? fontWeight,
    Color? color,
  }) {
    final weight = fontWeight ?? FontWeight.w400;

    switch (fontSize.toInt()) {
      case 10:
        return weight.index >= FontWeight.w500.index
            ? AppTypography.labelSmall(color: color)
            : AppTypography.bodySmall(color: color);
      case 11:
      case 12:
        return weight.index >= FontWeight.w500.index
            ? AppTypography.labelSmall(color: color)
            : AppTypography.bodySmall(color: color);
      case 13:
      case 14:
        return weight.index >= FontWeight.w500.index
            ? AppTypography.labelMedium(color: color)
            : AppTypography.bodyMedium(color: color);
      case 15:
      case 16:
        return weight.index >= FontWeight.w500.index
            ? AppTypography.labelLarge(color: color)
            : AppTypography.bodyLarge(color: color);
      case 17:
      case 18:
        return AppTypography.heading5(color: color);
      case 19:
      case 20:
        return AppTypography.heading4(color: color);
      case 21:
      case 22:
      case 23:
      case 24:
        return AppTypography.heading3(color: color);
      case 25:
      case 26:
      case 27:
      case 28:
        return AppTypography.heading2(color: color);
      default:
        if (fontSize >= 29) {
          return AppTypography.heading1(color: color);
        }
        return AppTypography.bodyMedium(color: color);
    }
  }

  /// Recommended replacements for common patterns
  static String getRecommendedReplacement(String originalStyle) {
    // Remove extra whitespace and normalize
    final normalized = originalStyle.replaceAll(RegExp(r'\s+'), ' ').trim();

    for (final entry in _migrationMap.entries) {
      if (normalized.contains(entry.key)) {
        return entry.value;
      }
    }

    // Default fallback
    if (normalized.contains('fontSize: 12')) return 'AppTypography.bodySmall()';
    if (normalized.contains('fontSize: 14'))
      return 'AppTypography.bodyMedium()';
    if (normalized.contains('fontSize: 16')) return 'AppTypography.bodyLarge()';
    if (normalized.contains('fontSize: 18')) return 'AppTypography.heading5()';
    if (normalized.contains('fontSize: 20')) return 'AppTypography.heading4()';
    if (normalized.contains('fontSize: 24')) return 'AppTypography.heading3()';

    return 'AppTypography.bodyMedium()'; // Safe default
  }
}
