import 'package:flutter/material.dart';
import 'package:planago/utils/constants/colors.dart';
import 'package:planago/utils/theme/text_theme.dart';

class AppTheme 
{
  AppTheme._();
  static ThemeData defaultTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary, // Your custom primary color
      primary: AppColors.primary,
      secondary: AppColors.secondary,
    ),
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.mutedWhite,
    textTheme: AppTextTheme.defaultTheme,
  );
}
