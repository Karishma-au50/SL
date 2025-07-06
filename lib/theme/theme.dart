import 'package:flutter/material.dart';

import '../shared/app_colors.dart';


/// To customize the app theme need to changes things in this method
ThemeData lightThemeData(BuildContext context) {
  return ThemeData(
    splashColor: Colors.transparent,
    textSelectionTheme:
        const TextSelectionThemeData(cursorColor: AppColors.kcCaptionLightGray),
    primaryColor: AppColors.kcPrimaryColor,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 0, foregroundColor: Colors.white),
    brightness: Brightness.light,
    dividerColor: AppColors.kcCaptionDarkGray.withOpacity(0.1),
    focusColor: AppColors.kcPrimaryColor,
    hintColor: AppColors.kcDefaultText,
    colorScheme: const ColorScheme.light(
        primary: AppColors.kcPrimaryColor, secondary: AppColors.kcPrimaryColor),
    textTheme: Theme.of(context).textTheme,
  );
}
