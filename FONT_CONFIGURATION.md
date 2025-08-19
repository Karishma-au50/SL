# TT Firs Neue Font Configuration Guide

## Overview

This document explains how to use the TT Firs Neue font family that has been configured in your Flutter app.

## Font Families Configured

### 1. TT Firs Neue Trial

The main font family with all weight variants:

- **Thin (100)** - TT Firs Neue Trial Thin.ttf
- **ExtraLight (200)** - TT Firs Neue Trial ExtraLight.ttf
- **Light (300)** - TT Firs Neue Trial Light.ttf
- **Regular (400)** - TT Firs Neue Trial Regular.ttf
- **Medium (500)** - TT Firs Neue Trial Medium.ttf
- **DemiBold (600)** - TT Firs Neue Trial DemiBold.ttf
- **Bold (700)** - TT Firs Neue Trial Bold.ttf
- **ExtraBold (800)** - TT Firs Neue Trial ExtraBold.ttf
- **Black (900)** - TT Firs Neue Trial Black.ttf

Each weight also includes italic variants.

### 2. TT Firs Neue Trial Var

Variable font family:

- **Roman (400)** - TT Firs Neue Trial Var Roman.ttf
- **Italic (400)** - TT Firs Neue Trial Var Italic.ttf

## Usage Examples

### Using AppTypography Class (Recommended)

```dart
// Your custom style matching the requirements
Text(
  'Title Text',
  style: AppTypography.ttFirsNeueTitle(color: Colors.black87),
)

// Other predefined styles
Text('Heading', style: AppTypography.heading1())
Text('Body text', style: AppTypography.bodyLarge())
Text('Label', style: AppTypography.labelMedium())
```

### Using Direct TextStyle

```dart
// Using the main font family
Text(
  'Custom Text',
  style: TextStyle(
    fontFamily: 'TT Firs Neue Trial',
    fontSize: 16,
    fontWeight: FontWeight.w600, // DemiBold
  ),
)

// Using the variable font family
Text(
  'Variable Font Text',
  style: TextStyle(
    fontFamily: 'TT Firs Neue Trial Var',
    fontSize: 18,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
  ),
)
```

### Using FontHelper Class

```dart
// Custom typography with TT Firs Neue
Text(
  'Custom Text',
  style: FontHelper.customTypography(
    fontFamily: 'TT Firs Neue Trial',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.blue,
  ),
)

// Your specific title style
Text(
  'Title',
  style: FontHelper.ttFirsNeueTitle(color: Colors.black87),
)
```

## Font Weight Mapping

| Font Weight | Value           | Font File                         |
| ----------- | --------------- | --------------------------------- |
| Thin        | FontWeight.w100 | TT Firs Neue Trial Thin.ttf       |
| ExtraLight  | FontWeight.w200 | TT Firs Neue Trial ExtraLight.ttf |
| Light       | FontWeight.w300 | TT Firs Neue Trial Light.ttf      |
| Regular     | FontWeight.w400 | TT Firs Neue Trial Regular.ttf    |
| Medium      | FontWeight.w500 | TT Firs Neue Trial Medium.ttf     |
| DemiBold    | FontWeight.w600 | TT Firs Neue Trial DemiBold.ttf   |
| Bold        | FontWeight.w700 | TT Firs Neue Trial Bold.ttf       |
| ExtraBold   | FontWeight.w800 | TT Firs Neue Trial ExtraBold.ttf  |
| Black       | FontWeight.w900 | TT Firs Neue Trial Black.ttf      |

## Testing Fonts

Use the `FontTestScreen` widget to test all font weights and styles:

```dart
import 'package:sl/examples/font_test_screen.dart';

// Navigate to the test screen
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const FontTestScreen()),
);
```

## Font Configuration in pubspec.yaml

The fonts are configured as follows:

```yaml
fonts:
  - family: TT Firs Neue Trial
    fonts:
      - asset: assets/fonts/TT Firs Neue Trial Regular.ttf
        weight: 400
      - asset: assets/fonts/TT Firs Neue Trial DemiBold.ttf
        weight: 600
      # ... (all other weights)
  - family: TT Firs Neue Trial Var
    fonts:
      - asset: assets/fonts/TT Firs Neue Trial Var Roman.ttf
        weight: 400
      - asset: assets/fonts/TT Firs Neue Trial Var Italic.ttf
        weight: 400
        style: italic
```

## Performance Tips

1. **Use specific weights**: Only specify the font weights you actually use in your app
2. **Preload fonts**: Consider preloading fonts that are used frequently
3. **Test on device**: Always test fonts on actual devices to ensure proper rendering

## Troubleshooting

### Font not displaying correctly

1. Ensure `flutter pub get` has been run after modifying pubspec.yaml
2. Check that font file names in pubspec.yaml match exactly with files in assets/fonts/
3. Verify the fontFamily name matches what's declared in pubspec.yaml

### Font weight not working

1. Make sure the specific weight is declared in pubspec.yaml
2. Check that the corresponding font file exists
3. Use the exact FontWeight values mapped in the table above

## Custom Typography Constants

Access font family names through constants:

```dart
AppTypography.ttFirsNeue        // 'TT Firs Neue Trial'
AppTypography.ttFirsNeueVar     // 'TT Firs Neue Trial Var'
```
