# Typography Migration Guide

## Overview

This guide helps you migrate all static TextStyle instances to use AppTypography across your Flutter application.

## ✅ Completed Files

- ✅ `lib/features/auth/views/login_screen.dart` - Fully migrated
- ✅ `lib/features/auth/views/register_screen.dart` - Fully migrated

## 🔄 Files Needing Migration

### High Priority (Core UI)

- `lib/features/home/views/home_screen.dart` - 13 TextStyle instances
- `lib/features/splash/splash_screen.dart`
- `lib/features/profile/profile_screen.dart`

### Medium Priority (Feature Screens)

- `lib/features/myPoints/views/my_points_screen.dart`
- `lib/features/wallet/wallet_screen.dart`
- `lib/features/notifications/notification_screen.dart`

### Low Priority (Secondary Screens)

- `lib/features/aboutUs/about_us_screen.dart`
- `lib/features/FAQs/faqs_screen.dart`
- `lib/features/chatWithUs/chat_with_us_screen.dart`

## Migration Patterns

### Common Replacements

| Original TextStyle                                     | AppTypography Replacement     |
| ------------------------------------------------------ | ----------------------------- |
| `TextStyle(fontSize: 12)`                              | `AppTypography.bodySmall()`   |
| `TextStyle(fontSize: 14)`                              | `AppTypography.bodyMedium()`  |
| `TextStyle(fontSize: 16)`                              | `AppTypography.bodyLarge()`   |
| `TextStyle(fontSize: 18, fontWeight: FontWeight.bold)` | `AppTypography.heading5()`    |
| `TextStyle(fontSize: 20, fontWeight: FontWeight.w600)` | `AppTypography.heading4()`    |
| `TextStyle(fontSize: 24, fontWeight: FontWeight.bold)` | `AppTypography.heading3()`    |
| `TextStyle(fontSize: 12, fontWeight: FontWeight.w500)` | `AppTypography.labelSmall()`  |
| `TextStyle(fontSize: 14, fontWeight: FontWeight.w500)` | `AppTypography.labelMedium()` |
| `TextStyle(fontSize: 16, fontWeight: FontWeight.w500)` | `AppTypography.labelLarge()`  |

### With Colors

| Original                                                                      | Replacement                                       |
| ----------------------------------------------------------------------------- | ------------------------------------------------- |
| `TextStyle(fontSize: 14, color: Colors.grey)`                                 | `AppTypography.bodyMedium(color: Colors.grey)`    |
| `TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)` | `AppTypography.labelLarge(color: Colors.black87)` |

### Special Cases

| Original                                                                                 | Replacement                       | Note              |
| ---------------------------------------------------------------------------------------- | --------------------------------- | ----------------- |
| `TextStyle(fontFamily: 'TT Firs Neue Trial', fontSize: 20, fontWeight: FontWeight.w600)` | `AppTypography.ttFirsNeueTitle()` | Your custom style |
| `TextStyle(fontSize: 11)`                                                                | `AppTypography.caption()`         | Very small text   |
| `TextStyle(fontWeight: FontWeight.w600, fontSize: 12)`                                   | `AppTypography.labelSmall()`      | Button/label text |

## Migration Steps

### 1. Find TextStyle Instances

```bash
# Search for TextStyle in a specific file
grep -n "TextStyle" lib/features/home/views/home_screen.dart
```

### 2. Replace Common Patterns

Replace these patterns systematically:

```dart
// Before
const TextStyle(fontSize: 14, color: Colors.grey)

// After
AppTypography.bodyMedium(color: Colors.grey)
```

### 3. Remove const Keywords

When using AppTypography methods, remove `const` keywords:

```dart
// Before
const Text('Hello', style: TextStyle(fontSize: 16))

// After
Text('Hello', style: AppTypography.bodyLarge())
```

### 4. Handle Edge Cases

For unique styling not covered by AppTypography:

```dart
// Use AppTypography as base and modify
AppTypography.bodyLarge().copyWith(
  decoration: TextDecoration.underline,
  letterSpacing: 1.5,
)

// Or use the custom typography helper
AppTypography.withCustomFont(
  fontFamily: 'CustomFont',
  fontSize: 18,
  fontWeight: FontWeight.w500,
)
```

## Verification

After migration, check for:

1. No compilation errors
2. Consistent visual appearance
3. Proper TT Firs Neue font usage
4. No remaining `TextStyle` instances (except edge cases)

## Tools

Use the `TypographyMigrationHelper` class for guidance:

```dart
TypographyMigrationHelper.getRecommendedReplacement('fontSize: 14, fontWeight: FontWeight.bold')
// Returns: 'AppTypography.labelMedium()'
```

## Benefits After Migration

1. **Consistency** - All text uses the same typography system
2. **Maintainability** - Easy to update fonts globally
3. **TT Firs Neue Integration** - Proper custom font usage
4. **Responsive Design** - Built-in responsive text scaling
5. **Clean Code** - Semantic naming instead of hardcoded values
