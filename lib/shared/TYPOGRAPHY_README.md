# Typography System Documentation

This document explains how to use the typography system implemented in this Flutter project.

## Overview

The typography system provides two main classes for managing text styles:

1. **AppTypography** - A comprehensive typography system with semantic naming
2. **FontHelper** - Utility class with size-weight based naming and helper functions

## AppTypography Class

The `AppTypography` class provides semantic text styles following design system principles.

### Usage

```dart
import 'package:sl/shared/typography.dart';

// Basic usage
Text(
  'Your text here',
  style: AppTypography.heading1(color: Colors.black87),
)

// The special TT Firs Neue title style (matching your requirements)
Text(
  'Login with Mobile Number',
  style: AppTypography.ttFirsNeueTitle(color: Colors.black87),
)
```

### Available Styles

#### Headings

- `AppTypography.heading1()` - 32px, w700
- `AppTypography.heading2()` - 28px, w600
- `AppTypography.heading3()` - 24px, w600
- `AppTypography.heading4()` - 20px, w600
- `AppTypography.heading5()` - 18px, w600
- `AppTypography.heading6()` - 16px, w600

#### Body Text

- `AppTypography.bodyLarge()` - 16px, w400
- `AppTypography.bodyMedium()` - 14px, w400
- `AppTypography.bodySmall()` - 12px, w400

#### Labels

- `AppTypography.labelLarge()` - 14px, w500
- `AppTypography.labelMedium()` - 12px, w500
- `AppTypography.labelSmall()` - 10px, w500

#### Buttons

- `AppTypography.buttonLarge()` - 16px, w600
- `AppTypography.buttonMedium()` - 14px, w600
- `AppTypography.buttonSmall()` - 12px, w600

#### Special Styles

- `AppTypography.ttFirsNeueTitle()` - Your custom 20px, w600 style
- `AppTypography.caption()` - 12px, w400
- `AppTypography.overline()` - 10px, w500, letter-spacing: 1.5

### Utility Methods

#### Custom Font Typography

```dart
Text(
  'Custom font text',
  style: AppTypography.withCustomFont(
    fontFamily: 'YourCustomFont',
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Colors.blue,
  ),
)
```

#### Responsive Typography

```dart
Text(
  'Responsive text',
  style: AppTypography.responsive(
    context,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  ),
)
```

#### Apply Theme to Existing Style

```dart
Text(
  'Modified style',
  style: AppTypography.applyTheme(
    AppTypography.bodyLarge(),
    color: Colors.red,
    fontSize: 18,
  ),
)
```

## FontHelper Class

The `FontHelper` class provides utility methods and size-weight based naming.

### Usage

```dart
import 'package:sl/shared/font_helper.dart';

// Size-weight based naming
Text(
  'Your text',
  style: FontHelper.ts16w600(color: Colors.black),
)

// Custom typography helper
Text(
  'Custom text',
  style: FontHelper.customTypography(
    fontFamily: 'CustomFont',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.blue,
  ),
)
```

### Available Styles

The naming convention is `ts{size}w{weight}`:

- `ts10w400()`, `ts10w500()`, `ts10w600()`, `ts10w700()`
- `ts12w400()`, `ts12w500()`, `ts12w600()`, `ts12w700()`
- `ts14w400()`, `ts14w500()`, `ts14w600()`, `ts14w700()`
- `ts16w400()`, `ts16w500()`, `ts16w600()`, `ts16w700()`
- `ts18w400()`, `ts18w500()`, `ts18w600()`, `ts18w700()`
- `ts20w400()`, `ts20w500()`, `ts20w600()`, `ts20w700()`
- And more...

### Utility Methods

#### Custom Typography

```dart
FontHelper.customTypography(
  fontFamily: 'TT Firs Neue Trial Var Roman',
  fontSize: 20,
  fontWeight: FontWeight.w600,
  height: 1.0,
  letterSpacing: 0.0,
  color: Colors.black87,
)
```

#### Responsive Text Style

```dart
FontHelper.responsiveTextStyle(
  context,
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: Colors.black,
)
```

#### Apply TT Firs Neue to Existing Style

```dart
FontHelper.withTTFirsNeue(existingTextStyle)
```

## Best Practices

1. **Use AppTypography for semantic styles** - Better for maintainability
2. **Use FontHelper for specific size-weight combinations** - When you need exact control
3. **Always specify colors** - Don't rely on default colors
4. **Use responsive methods for dynamic content** - Better UX across devices
5. **Prefer semantic naming** - `heading1` is better than `ts32w700`

## Font Setup

Make sure to add the TT Firs Neue font to your `pubspec.yaml`:

```yaml
flutter:
  fonts:
    - family: TT Firs Neue Trial Var Roman
      fonts:
        - asset: assets/fonts/TTFirsNeueTrialVarRoman-Regular.ttf
        - asset: assets/fonts/TTFirsNeueTrialVarRoman-Bold.ttf
          weight: 700
```

## Example Implementation

See `lib/examples/typography_example.dart` for a complete example of all typography styles in action.

## Migration

To migrate existing hardcoded TextStyles:

**Before:**

```dart
Text(
  'Login with Mobile Number',
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  ),
)
```

**After:**

```dart
Text(
  'Login with Mobile Number',
  style: AppTypography.ttFirsNeueTitle(color: Colors.black87),
)
```

This provides better consistency, maintainability, and follows design system principles.
