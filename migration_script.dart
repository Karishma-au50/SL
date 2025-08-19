// Bulk Migration Script for AppTypography
// This script shows the migration patterns that need to be applied across all files

import 'dart:io';

void main() {
  print('AppTypography Migration Patterns:');
  print('');

  // Common migration mappings
  final Map<String, String> migrationMap = {
    // Text style patterns
    'TextStyle(fontSize: 12, color: Colors.grey)':
        'AppTypography.bodySmall(color: Colors.grey)',
    'TextStyle(fontSize: 12, fontWeight: FontWeight.w600)':
        'AppTypography.labelSmall()',
    'TextStyle(fontSize: 14, fontWeight: FontWeight.w400)':
        'AppTypography.bodyMedium()',
    'TextStyle(fontSize: 16, fontWeight: FontWeight.w500)':
        'AppTypography.labelLarge()',
    'TextStyle(fontSize: 18, fontWeight: FontWeight.bold)':
        'AppTypography.heading5()',
    'TextStyle(fontSize: 20, fontWeight: FontWeight.w600)':
        'AppTypography.heading4()',
    'TextStyle(fontSize: 24, fontWeight: FontWeight.bold)':
        'AppTypography.heading3()',

    // FontHelper patterns
    'FontHelper.ts12w400()': 'AppTypography.bodySmall()',
    'FontHelper.ts14w400()': 'AppTypography.bodyMedium()',
    'FontHelper.ts16w600()': 'AppTypography.labelLarge()',
    'FontHelper.ts18w400()': 'AppTypography.heading5()',
    'FontHelper.ts18w600()': 'AppTypography.heading5()',
    'FontHelper.ts20w600()': 'AppTypography.heading4()',

    // Const TextStyle patterns
    'const TextStyle(fontSize: 12)': 'AppTypography.bodySmall()',
    'const TextStyle(fontSize: 14)': 'AppTypography.bodyMedium()',
    'const TextStyle(fontSize: 16)': 'AppTypography.bodyLarge()',
    'const TextStyle(fontSize: 18)': 'AppTypography.heading5()',
    'const TextStyle(fontSize: 20)': 'AppTypography.heading4()',
  };

  for (var entry in migrationMap.entries) {
    print('Replace: ${entry.key}');
    print('With:    ${entry.value}');
    print('');
  }
}

// Files that need migration:
final List<String> filesToMigrate = [
  'lib/features/profile/profile_screen.dart',
  'lib/features/myPoints/views/my_points_screen.dart',
  'lib/features/splash/splash_screen.dart',
  'lib/features/notifications/notification_screen.dart',
  'lib/features/chatWithUs/chat_with_us_screen.dart',
  'lib/features/aboutUs/about_us_screen.dart',
  'lib/features/FAQs/faqs_screen.dart',
  'lib/features/auth/views/otp_screen.dart',
  'lib/features/language/language_screen.dart',
  'lib/widgets/customBottomNavigation/custom_bottom_navigationbar.dart',
  'lib/widgets/toast/my_toast.dart',
];
